FROM golang:1-alpine

WORKDIR /app

# Install dev tools: air (hot-reload) and swag (OpenAPI spec generation)
RUN go install github.com/air-verse/air@latest && \
    go install github.com/swaggo/swag/cmd/swag@latest

# Installing dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copying sources
COPY . .

# Run with hot-reload
EXPOSE 8080
ENTRYPOINT ["air"]
