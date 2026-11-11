# ============================================================
# LMS Development Makefile
# ============================================================

.PHONY: help dev dev-backend dev-frontend dev-postgres down migrate makemigrations createsuperuser test-backend lint-backend lint-frontend schema shell clean

# Default target
help:
	@echo "LMS Development Commands:"
	@echo "  make dev              - Start all services with docker-compose"
	@echo "  make dev-postgres     - Start services with PostgreSQL profile"
	@echo "  make dev-backend      - Run Django development server locally"
	@echo "  make dev-frontend     - Run Vite dev server locally"
	@echo "  make down             - Stop all docker containers"
	@echo "  make migrate          - Run Django migrations in container"
	@echo "  make makemigrations   - Create Django migrations in container"
	@echo "  make createsuperuser  - Create Django superuser in container"
	@echo "  make test-backend     - Run Django tests in container"
	@echo "  make lint-backend     - Run Ruff linter on backend code"
	@echo "  make lint-frontend    - Run ESLint on frontend code"
	@echo "  make schema           - Generate OpenAPI schema"
	@echo "  make shell            - Open Django shell in container"
	@echo "  make logs             - View docker-compose logs"
	@echo "  make clean            - Remove docker volumes and images"

# Development servers
dev-backend:
	cd backend && python manage.py runserver

dev-frontend:
	cd frontend && npm run dev

# Docker Compose commands
dev:
	docker-compose up --build

dev-postgres:
	docker-compose --profile postgres up --build

down:
	docker-compose down

logs:
	docker-compose logs -f

# Django commands (in container)
migrate:
	docker-compose exec web python manage.py migrate

makemigrations:
	docker-compose exec web python manage.py makemigrations

createsuperuser:
	docker-compose exec web python manage.py createsuperuser

test-backend:
	docker-compose exec web python manage.py test

shell:
	docker-compose exec web python manage.py shell

# Linting
lint-backend:
	cd backend && ruff check .

lint-frontend:
	cd frontend && npm run lint

# Schema generation
schema:
	docker-compose exec web python manage.py spectacular --file schema.yml

# Cleanup
clean:
	docker-compose down -v --rmi all

# Production
prod-up:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

prod-down:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml down
