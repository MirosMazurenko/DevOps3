# First stage: build the software in a GCC image
FROM gcc:latest AS build

# Set the working directory
WORKDIR /usr/src/app

# Clone the repository from GitHub (replace <repo_url> with the actual URL)
RUN git clone --branch branchHTTPserver https://github.com/MirosMazurenko/DevOps3.git

# Compile the application
RUN g++ -std=c++17 -o http_server HTTP_Server.cpp funcA.cpp

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
