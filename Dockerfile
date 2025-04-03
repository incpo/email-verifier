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

# Expose the port (API server listens on 8081 as configured in main.go)
EXPOSE 8081

# Run the binary
CMD ["./apiserver"]