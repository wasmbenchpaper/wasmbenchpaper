#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

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
    int port = 8080;
    if (argc == 2)
    {
        port = atoi(argv[1]);
        if (port <= 0 || port > 65535)
        {
            printf("got an invalid port number. actual: '%s'\n", argv[1]);
            exit(1);
        }
    }
    // printf("using port %d\n", port);
    int server_fd, new_socket, valread;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);

    // Creating socket file descriptor
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
    {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(port);

    // Forcefully attaching socket to the port 8080
    if (bind(server_fd, (struct sockaddr *)&address,
             sizeof(address)) < 0)
    {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }
    if (listen(server_fd, 3) < 0)
    {
        perror("listen");
        exit(EXIT_FAILURE);
    }
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