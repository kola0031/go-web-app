# Build stage
FROM golang:1.22.5-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Install git for go mod download (alpine doesn't include it by default)
RUN apk add --no-cache git

# Copy the Go modules manifests
COPY go.mod ./

# Download the Go modules
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the application with specific OS/arch for better compatibility
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o main .

# Final stage
FROM gcr.io/distroless/base-debian12

# Create app directory
WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/main .

# Copy static files
COPY --from=builder /app/static ./static

# Expose the port the app runs on
EXPOSE 8080

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD ["/app/main", "-health-check"] || exit 1

# Set the command to run the binary
CMD ["/app/main"]