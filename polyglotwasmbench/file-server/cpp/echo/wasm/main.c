#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>
#include <fcntl.h>

// is_blocking = 0 means false
// is_blocking = 1 means true
int set_blocking_mode(int socket, int is_blocking)
{
    const int flags = fcntl(socket, F_GETFL, 0);
    if ((flags & O_NONBLOCK) && !is_blocking) { printf("set_blocking_mode(): socket was already in non-blocking mode\n"); return 0; }
    if (!(flags & O_NONBLOCK) && is_blocking) { printf("set_blocking_mode(): socket was already in blocking mode\n"); return 0; }
    return fcntl(socket, F_SETFL, is_blocking ? flags ^ O_NONBLOCK : flags | O_NONBLOCK);
}

int handle_conn(int new_socket)
{
    while (1)
    {
        char buffer[1024] = {0};

        // read
        int valread = read(new_socket, buffer, 1024);
        if (valread < 0)
            break;
        // printf("[recv %d bytes] %s", valread, buffer);
        char path[1024];

        // echo
        send(new_socket, buffer, strlen(buffer), 0);
        // printf("[info] echo sent\n");
    }

    return 0;
}

int main(int argc, char const *argv[])
{
    int server_fd, new_socket, valread;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);
    char *hello = "Hello from server";

    server_fd = 3;
    // set socket to blocking mode
    if (set_blocking_mode(server_fd, 1)) {
        printf("failed to set the socket to non-blocking mode\n");
        exit(1);
    }
    // wait to accept a connection
    if ((new_socket = accept(server_fd, (struct sockaddr *)&address,
                             (socklen_t *)&addrlen)) < 0)
    {
        perror("accept");
        exit(EXIT_FAILURE);
    }
    handle_conn(new_socket);

    // closing the connected socket
    close(new_socket);
    // closing the listening socket
    shutdown(server_fd, SHUT_RDWR);
    return 0;
}