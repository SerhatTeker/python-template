# -------------------------------------------------------------------------------------
# LOCAL DEV - Django
# -------------------------------------------------------------------------------------

# Variables
# -------------------------------------------------------------------------------------
ENV_DJANGO				:= $(DJANGO_DIR)/.env
PROJECT_NAME			?= project
PROJECT_DIR				:= $(ROOT_DIR)/$(PROJECT_NAME)
DB_SQLITE				:= $(ROOT_DIR)/db.sqlite3
DJANGO_DEV_ADMIN_LOCAL	?= testadmin:testadmin@testapi.com:123asX3?23
DJANGO_PORT				:= 8000
LOCAL_HOST				:= 127.0.0.1
UVICORN_APP				:= $(PROJECT_NAME).asgi:application
# Commands
RM				:= rm -rf
DJANGO_ADMIN	:= django-admin
MANAGE			:= $(ROOT_DIR)/manage.py

# Django env
include $(ENV_DJANGO)

# Export all variable to sub-make/shell
export

.PHONY: help debug startproject install-django migrate create-superuser django-shell runserver test coverage clean

.DEFAULT_GOAL := help

help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Setup
# -------------------------------------------------------------------------------------
startproject: install-django start-project migrate create-superuser ## Setup Django Project

# Install
# -------------------------------------------------------------------------------------
install-django: ## Install django requirements
	@echo "Installing django requirements"
	$(BIN)/pip install -r $(DJANGO_DIR)/requirements.txt

start-project: ## django-admin startproject
	@echo "Starting project: '$(PROJECT_NAME)'"
	$(DJANGO_ADMIN) startproject $(PROJECT_NAME) $(ROOT_DIR)

# DB
# -------------------------------------------------------------------------------------
migrate: ## Make migrate
	@echo "Running migrate"
	$(MANAGE) migrate

makemigrations: ## Make migrations
	$(MANAGE) makemigrations

allmigrations: makemigrations migrate ## Make migrations and migrate

createsecret: ## Create DJANGO_SECRET
	@echo "Creating SECRET_KEY"
	@echo "SECRET_KEY="\"`python manage.py shell -c 'from django.core.management import utils; print(utils.get_random_secret_key())'`\"

# Create a super user from env var
# You need to define an env var : DJANGO_DEV_ADMIN_LOCAL. Example below
# DJANGO_DEV_ADMIN_LOCAL=name:email:password
# DJANGO_DEV_ADMIN_LOCAL=testadmin:testadmin@testapi.com:123asX3?23
# Or Make get it from .envs/.local/.django
create-superuser: ## Create local django admin user.
	@echo "Creating super user from: '$(DJANGO_DEV_ADMIN_LOCAL)'"
	@echo "from django.contrib.auth import get_user_model;"\
		"User = get_user_model();" \
		"User.objects.create_superuser(*'$(DJANGO_DEV_ADMIN_LOCAL)'.split(':'))" \
		| $(PYTHON) $(MANAGE) shell

# Run
# -------------------------------------------------------------------------------------
django-shell: ## Run ipython in django shell
	@echo "Running tests"
	$(MANAGE) shell -i ipython

runserver: ## Run the Django server
	$(MANAGE) runserver $(DJANGO_PORT)

runserver-async: ## Run the Django async server
	@cd $(ROOT_DIR) && uvicorn $(UVICORN_APP) --host $(LOCAL_HOST) --port $(DJANGO_PORT) --reload

# Test
# -------------------------------------------------------------------------------------
test: coverage ## Run tests and make coverage report

coverage: ## Clear and run coverage report
	@echo "Running tests"
	coverage erase
	coverage run -m pytest
	coverage report -m
	coverage html

# Clean
# -------------------------------------------------------------------------------------
clean: ## Clean startproject
	@echo "Cleaning Django Project"
	@$(RM) $(MANAGE) $(DB_SQLITE) $(PROJECT_DIR)
