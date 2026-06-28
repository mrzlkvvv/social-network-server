FROM golang:1-alpine AS builder
WORKDIR /build

# Install swag (OpenAPI spec generation)
RUN go install github.com/swaggo/swag/cmd/swag@latest

# Download dependencies
COPY go.mod go.sum ./
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download

# Build binary
COPY . .
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    swag init -g cmd/main.go -o ./docs --parseDependency && \
    go build -o /build/backend ./cmd/main.go

FROM scratch
WORKDIR /app
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /build/backend /app/backend
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
USER nobody:nobody
EXPOSE 8080
ENTRYPOINT ["./backend"]
