.SILENT:

COMPOSE	:= docker compose -p social-network

COMPOSE_DEV  := ./deploy/docker-compose.dev.yml
COMPOSE_PROD := ./deploy/docker-compose.prod.yml

up-dev:
	$(COMPOSE) -f $(COMPOSE_DEV) up --build

up-prod:
	$(COMPOSE) -f $(COMPOSE_PROD) up --build

down-dev:
	$(COMPOSE) -f $(COMPOSE_DEV) down --remove-orphans

down-prod:
	$(COMPOSE) -f $(COMPOSE_DEV) down

update:
	go get -u ./...
	go mod tidy

lint:
	golangci-lint run ./{cmd,internal}/...

test:
	go test ./{cmd,internal}/...
