# ==========================================
# STAGE 1: The Build Environment
# ==========================================
FROM golang:1.23-alpine AS builder

# Install git and certificates (in case your Go app pulls private modules)
RUN apk add --no-cache git ca-certificates

WORKDIR /app

# Optimization Trick: Copy dependency descriptors first.
# This layer caches automatically and won't re-run unless go.mod updates.
COPY go.mod go.sum* ./
RUN go mod download

# Copy the rest of your application code
COPY . .

# Compile the Go application with optimization flags:
# - CGO_ENABLED=0 builds a completely self-sufficient static binary.
# - ldflags "-s -w" strips debugging symbols to shrink the file size by roughly 40%.
RUN CGO_ENABLED=0 GOOS=linux go build \
    -ldflags="-s -w" \
    -o /go-webserver .

# ==========================================
# STAGE 2: The Secure Runtime Environment
# ==========================================
FROM alpine:3.21

# Security Best Practice: Create a non-privileged user
RUN adduser -D -g '' appuser

WORKDIR /app

# Pull only the compiled binary and the CA certificates from the builder stage
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go-webserver ./go-webserver

# Switch from root to our restricted user to protect the host environment
USER appuser

# Expose port metadata
EXPOSE 8080

# Execute the binary directly
ENTRYPOINT ["./go-webserver"]
