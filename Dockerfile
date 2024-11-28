# Use an official C++ runtime as a parent image
FROM gcc:latest
# Set the working directory
WORKDIR /usr/src/app
# Copy the source files
COPY . .
# Compile the application
RUN g++ -std=c++17 -o http_server HTTP_Server.cpp funcA.cpp
# Expose the port
EXPOSE 8081
# Run the HTTP server
CMD ["./http_server"]
