FROM golang:1.22.5 AS base  

# Set the working directory inside the container
WORKDIR /app    

# Copy the Go modules manifests
COPY go.mod .       

# Download the Go modules
RUN go mod download     

# Copy the source code into the container
COPY . .

RUN go build -o main .

# Use a minimal base image for the final build
FROM gcr.io/distroless/base
# Copy the built binary from the previous stage
COPY --from=base /app/main / 
# Set the command to run the binary

COPY --from=base /app/static ./static
CMD ["/main"]
# Expose the port the app runs on
EXPOSE 8080