#include <iostream>
#include <vector>
#include <random>
#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstring>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include "funcA.h"

#define PORT 8081

void handleClient(int clientSocket);

int main() {
    int serverSocket, clientSocket;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);

    // Create socket
    if ((serverSocket = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("Socket failed");
        exit(EXIT_FAILURE);
    }

    // Configure socket options
    if (setsockopt(serverSocket, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &opt, sizeof(opt))) {
        perror("setsockopt");
        close(serverSocket);
        exit(EXIT_FAILURE);
    }

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    // Bind the socket
    if (bind(serverSocket, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("Bind failed");
        close(serverSocket);
        exit(EXIT_FAILURE);
    }

    // Listen for incoming connections
    if (listen(serverSocket, 10) < 0) {
        perror("Listen failed");
        close(serverSocket);
        exit(EXIT_FAILURE);
    }

    std::cout << "HTTP Server is running on port " << PORT << "...\n";

    // Main loop to accept and handle clients
    while (true) {
        std::cout << "Waiting for a new connection...\n";
        if ((clientSocket = accept(serverSocket, (struct sockaddr *)&address, (socklen_t *)&addrlen)) < 0) {
            perror("Accept failed");
            close(serverSocket);
            exit(EXIT_FAILURE);
        }

        std::cout << "New connection accepted.\n";
        handleClient(clientSocket);
        close(clientSocket);
    }

    close(serverSocket);
    return 0;
}

void handleClient(int clientSocket) {
    char buffer[30000] = {0};
    read(clientSocket, buffer, 30000);

    std::cout << "Client request:\n" << buffer << "\n";

    // Parse the request method and path
    std::string request(buffer);
    size_t methodEnd = request.find(' ');
    size_t pathEnd = request.find(' ', methodEnd + 1);

    std::string method = request.substr(0, methodEnd);
    std::string path = request.substr(methodEnd + 1, pathEnd - methodEnd - 1);

    std::cout << "Method: " << method << "\n";
    std::cout << "Path: " << path << "\n";

    if (method == "GET" && path == "/compute") {
        FuncA func;
        std::vector<double> values;
        values.reserve(2000000);

        // Generate random inputs and compute values
        std::mt19937 rng{123};
        std::uniform_real_distribution<double> distr{0.0, 1.0};
        for (int i = 0; i < 2000000; ++i) {
            values.push_back(func.compute(distr(rng), 5)); // Using 5 terms
        }

        // Measure sorting time
        auto start = std::chrono::high_resolution_clock::now();
        for (int i = 0; i < 1200; ++i) {
            std::sort(values.begin(), values.end());
        }
        auto end = std::chrono::high_resolution_clock::now();
        auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();

        // Prepare response
        std::string responseBody = std::to_string(elapsed) + " ms";
        std::string response = 
            "HTTP/1.1 200 OK\r\n"
            "Content-Type: text/plain\r\n"
            "Content-Length: " + std::to_string(responseBody.length()) + "\r\n\r\n" +
            responseBody;

        // Send response
        send(clientSocket, response.c_str(), response.length(), 0);
        std::cout << "Response sent:\n" << response << "\n";
    } else {
        // Respond with 404 for unsupported paths
        std::string response = 
            "HTTP/1.1 404 Not Found\r\n"
            "Content-Type: text/plain\r\n"
            "Content-Length: 13\r\n\r\n"
            "404 Not Found";
        send(clientSocket, response.c_str(), response.length(), 0);
        std::cout << "Response sent:\n" << response << "\n";
    }
}

