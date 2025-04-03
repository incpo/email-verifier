# Use the official Go image for building
FROM golang:1.22.12 AS builder

# Set the working directory
WORKDIR /app

# Copy the Go module files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the binary
RUN go build -o apiserver cmd/apiserver/main.go

# Use a minimal base image for the final stage
FROM ubuntu:jammy

# Copy the binary from the builder stage
COPY --from=builder /app/apiserver /app/apiserver

# Set the working directory
WORKDIR /app

# Expose the port (assuming the API server listens on 8080)
EXPOSE 8080

# Run the binary
CMD ["./apiserver"]