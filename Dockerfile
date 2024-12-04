# Use an official GCC image as a builder (temporary image)
FROM gcc:latest as builder

# Set the working directory
WORKDIR /usr/src/app

# Clone the repository from GitHub (replace with your actual repository URL)
RUN git clone https://github.com/MirosMazurenko/DevOps3.git .

# Compile the application
RUN g++ -std=c++17 -o http_server HTTP_Server.cpp funcA.cpp

# Use a smaller Alpine image for the final image
FROM alpine:latest

# Install dependencies for running the compiled binary (e.g., libc)
RUN apk add --no-cache libstdc++

# Set the working directory in the final image
WORKDIR /usr/src/app

# Copy the compiled executable from the builder image
COPY --from=builder /usr/src/app/http_server .

# Expose the port
EXPOSE 8081

# Run the HTTP server
CMD ["./http_server"]
