
#include <vector>
#include <string>
#include <utility>
#include <fstream>
#include <iterator>
#include <memory>
#include <cstdlib>
#include <cstdio>
#include <cstring>
#include <cassert>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <dirent.h>

#define MY_SOCKET_FD 3
#define MY_DIR_FD 4 // https://github.com/bytecodealliance/wasmtime/issues/3936#issuecomment-1088708988

std::string list_files_in_dir_as_json(const char *dir_path)
{
	//printf("[trace] list_files_in_dir_as_json called with dir_path '%s'\n", dir_path);

	int mydird = openat(MY_DIR_FD, dir_path, O_DIRECTORY | O_RDONLY);
	if (mydird < 0)
	{
		perror("failed to open the sub directory to get a descriptor");
		return "[]";
	}

	DIR *dp;
	struct dirent *ep;
	dp = fdopendir(mydird);
	if (dp == NULL)
	{
		perror("couldn't open the sub directory descriptor as a directory");
		return "[]";
	}
	std::vector<std::string> files;
	while ((ep = readdir(dp)) != NULL)
	{
		files.emplace_back(ep->d_name);
	}
	std::string ans = "[";
	for (int i = 0; i < files.size(); i++)
	{
		ans += "\"" + files[i] + "\"";
		if (i != files.size() - 1)
			ans += ", ";
	}
	(void)closedir(dp);
	return ans + "]";
}

char *read_file_into_memory(const char *file_path, size_t *file_size)
{
	//printf("[trace] read_file_into_memory called with file_path '%s'\n", file_path);
	int myfiled = openat(MY_DIR_FD, file_path, O_RDONLY);
	if (myfiled < 0)
	{
		perror("failed to open the file using directory descriptor");
		return NULL;
	}
	FILE *f = fdopen(myfiled, "rb");
	if (f == NULL)
	{
		perror("failed to open the file descriptor as a file");
		return NULL;
	}
	if (fseek(f, 0, SEEK_END) != 0)
	{
		perror("failed to seek to the end of the file");
		fclose(f);
		return NULL;
	}
	long fsize = ftell(f);
	if (fsize < 0)
	{
		perror("failed to tell the size of the file");
		fclose(f);
		return NULL;
	}
	if (fseek(f, 0, SEEK_SET) != 0) /* same as rewind(f); */
	{
		perror("failed to seek back to the beginning of the file");
		fclose(f);
		return NULL;
	}
	// printf("file size is %ld bytes\n", fsize);
	char *string = (char *)malloc(fsize + 1);
	if (string == NULL)
	{
		perror("failed to allocate enough memory to hold the file contents");
		fclose(f);
		return NULL;
	}
	if (fread(string, fsize, 1, f) != 1)
	{
		perror("failed to read the file contents");
		fclose(f);
		return NULL;
	}
	fclose(f);
	string[fsize] = 0;
	*file_size = fsize;
	return string;
}

static std::string read_one_line(int fd)
{
	char buf[256];
	int n = read(fd, buf, 256);
	int pos = 0;
	while (pos < n)
	{
		if (buf[pos] == '\r')
		{
			assert(pos + 1 < n);
			if (buf[pos + 1] == '\n')
			{
				break;
			}
		}
		pos++;
	}
	assert(pos > 0);
	assert(pos < n);
	return std::string(buf, pos);
}

static std::vector<std::string> string_split(const std::string &str, std::string delim)
{
	std::vector<std::string> ret;
	size_t pos = 0;
	while (pos <= str.length())
	{
		size_t end = str.find(delim, pos);
		if (end == std::string::npos)
		{
			ret.emplace_back(str.c_str() + pos);
			break;
		}
		ret.emplace_back(str.c_str() + pos, end - pos);
		pos = end + delim.size();
	}
	return ret;
}

std::string get_mime_type(const std::string &path)
{
	if (path == "")
		return "text/plain";
	std::vector<std::string> parts = string_split(path, ".");
	if (parts.size() < 2)
		return "application/octet-stream";
	std::string ext = parts[parts.size() - 1];
	if (ext == "html")
		return "text/html";
	if (ext == "js")
		return "text/javascript";
	if (ext == "json")
		return "application/json";
	if (ext == "css")
		return "text/css";
	if (ext == "gif")
		return "image/gif";
	if (ext == "ico")
		return "image/x-icon";
	if (ext == "png")
		return "image/png";
	if (ext == "jpeg")
		return "image/jpeg";
	if (ext == "jpg")
		return "image/jpg";
	if (ext == "mp4")
		return "video/mp4";
	if (ext == "mkv")
		return "video/x-matroska";
	if (ext == "md")
		return "text/plain";
	if (ext == "txt")
		return "text/plain";
	return "application/octet-stream";
}

static std::string build_header(int code, size_t n, const std::string &path)
{
	std::string status = "";
	switch (code)
	{
	case 200:
		status = "OK";
		break;
	case 404:
		status = "Not Found";
		break;
	default:
		assert(false);
	}
	std::string res = "HTTP/1.0 " + std::to_string(code) + " " + status + "\r\n";
	std::string mime_type = get_mime_type(path);
	res += "Content-Type: " + mime_type + "; charset=UTF-8\r\n"; // DEBUG: TODO <--- set correct mimetype based on file extension
	res += "Content-Length: " + std::to_string(n) + "\r\n";
	res += "\r\n";
	return res;
}

void sendall(int fd, std::string &data)
{
	size_t sent = 0;
	while (sent < data.length())
	{
		int n = send(fd, data.c_str() + sent, data.length() - sent, 0);
		assert(n >= 0);
		sent += n;
	}
}

void sendall(int fd, char *buf, size_t len)
{
	size_t sent = 0;
	while (sent < len)
	{
		int n = send(fd, buf + sent, len - sent, 0);
		assert(n >= 0);
		sent += n;
	}
}

void readall(int fd)
{
	char buf[256];
	while (true)
	{
		int n = read(fd, buf, 256);
		if (n < 0)
		{
			printf("[error] reading from socket: %s.\n", std::strerror(errno));
			break;
		}
		else if (n == 0)
		{
			break;
		}
	}
}

// is_blocking = 0 means false
// is_blocking = 1 means true
int set_blocking_mode(int socket, int is_blocking)
{
	const int flags = fcntl(socket, F_GETFL, 0);
	if ((flags & O_NONBLOCK) && !is_blocking)
	{
		// printf("set_blocking_mode(): socket was already in non-blocking mode\n");
		return 0;
	}
	if (!(flags & O_NONBLOCK) && is_blocking)
	{
		// printf("set_blocking_mode(): socket was already in blocking mode\n");
		return 0;
	}
	return fcntl(socket, F_SETFL, is_blocking ? flags ^ O_NONBLOCK : flags | O_NONBLOCK);
}

static void handle_connection(int fd, std::string &directory)
{
	std::string line = read_one_line(fd);
	std::vector<std::string> parts = string_split(line, " ");
	/*
	for (std::string const& str : parts) {
		//printf("[trace] got part %s\n", str.c_str());
	}
	*/
	assert(parts.size() > 1);
	std::string path = parts[1];
	//printf("[info] request for path '%s'\n", path.c_str());
	if (path == "/api/v1/files")
	{
		// API
		std::string files_json = list_files_in_dir_as_json(directory.c_str());
		//printf("[info] files_json: %s\n", files_json.c_str());
		std::string header = build_header(200, files_json.size(), "api.json");
		//printf("[info] sending the json response\n");
		sendall(fd, header);
		//printf("[info] json response header sent\n");
		sendall(fd, files_json);
		//printf("[info] json response body sent\n");
		readall(fd);
		//printf("[trace] read any remaining data from the connection\n");
		close(fd);
		//printf("[info] closed the connection\n");
		return;
	}
	if (path == "/")
	{
		path = "/index.html";
	}
	std::string final_path = directory + path;
	size_t file_size = 0;
	char *file_contents = read_file_into_memory(final_path.c_str(), &file_size);
	std::unique_ptr<char[]> data;
	size_t len;
	std::string header = "";
	// if (maybe_data.has_value())
	if (file_contents != NULL)
	{
		//printf("[info] successfully read the file\n");
		// data = std::move(maybe_data.value().first);
		data = std::unique_ptr<char[]>(file_contents);
		// len = maybe_data.value().second;
		len = file_size;
		header = build_header(200, len, path);
	}
	else
	{
		//printf("[info] failed to find the file\n");
		char not_found[] = "Not found.";
		len = strlen(not_found);
		data = std::make_unique<char[]>(len);
		memcpy(data.get(), not_found, len);
		header = build_header(404, len, "");
	}
	//printf("[info] sending the response\n");
	sendall(fd, header);
	//printf("[info] response header sent\n");
	sendall(fd, data.get(), len);
	//printf("[info] response body sent\n");
	readall(fd);
	//printf("[trace] read any remaining data from the connection\n");
	close(fd);
	//printf("[info] closed the connection\n");
}

int main(int argc, char *argv[])
{
	if (argc <= 3)
	{
		//printf("[info] usage: ./file_server <ip> <port> <directory>\n");
		return 1;
	}
	int port = std::atoi(argv[2]);
	int server_fd = 3;

	// In WASI instead of creating a socket we get passed in an existing socket on which we can call sock_accept
	// https://github.com/WebAssembly/wasi-libc/blob/a29c349a9868fc8dc2b0a6dd5ff6694bf8b7297c/libc-bottom-half/headers/public/wasi/api.h#L2016-L2031

	// int server_fd = socket(AF_INET, SOCK_STREAM, 0);
	// if (server_fd < 0)
	// {
	// 	printf("[error] unable to create socket.\n");
	// 	return 1;
	// }
	// struct sockaddr_in server_addr;
	// server_addr.sin_family = AF_INET;
	// server_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
	// inet_pton(AF_INET, argv[1], &server_addr.sin_addr);
	// server_addr.sin_port = htons(port);

	// if ((bind(server_fd, reinterpret_cast<struct sockaddr *>(&server_addr), sizeof(server_addr))) != 0)
	// {
	// 	printf("[error] unable to bind to %s:%d\n", argv[1], port);
	// 	return 1;
	// }

	// if (listen(server_fd, 1025) != 0)
	// {
	// 	printf("[error] unable to listen.\n");
	// 	return 1;
	// }

	// set socket to blocking mode
	if (set_blocking_mode(server_fd, 1))
	{
		printf("failed to set the socket to non-blocking mode\n");
		exit(1);
	}

	std::string directory = argv[3];

	{
		std::string files_json = list_files_in_dir_as_json(directory.c_str());
		// printf("[debug] files_json: %s\n", files_json.c_str());
	}

	while (true)
	{
		struct sockaddr_in client;
		int len = sizeof(client);
		int client_fd = accept(server_fd, reinterpret_cast<struct sockaddr *>(&client), reinterpret_cast<socklen_t *>(&len));
		if (client_fd < 0)
		{
			perror("server accept failed.");
			return 1;
		}
		handle_connection(client_fd, directory);
	}
	return 0;
}
