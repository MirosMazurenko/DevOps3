# First stage: build the software in a GCC image
FROM gcc:latest AS build

# Set the working directory
WORKDIR /usr/src/app

# Clone the repository from GitHub
RUN git clone --branch branchHTTPserver https://github.com/MirosMazurenko/DevOps3.git .

# List the files in the working directory for debugging
RUN ls -alh DevOps3

# Compile the application from the correct path
RUN g++ -std=c++17 -o http_server DevOps3/HTTP_Server.cpp DevOps3/funcA.cpp

# Second stage: use an Alpine-based image to run the software
FROM alpine:latest

# Install dependencies needed to run the application
RUN apk --no-cache add libc6-compat

# Set the working directory in the new image
WORKDIR /usr/src/app

# Copy the executable from the build stage
COPY --from=build /usr/src/app/http_server .

# Expose the port
EXPOSE 8081

# Run the HTTP server
CMD ["./http_server"]
