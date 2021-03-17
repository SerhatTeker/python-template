# Makefile for YADRTA Projects
SHELL := /bin/bash

# Variables
# -------------------------------------------------------------------------------------
VENV		:= ./.venv
ENV			:= ./.env
# ENVS		:= ./.envs
BIN			:= $(VENV)/bin
PYTHON3		:= $(BIN)/python3
PYTHON		:= $(PYTHON3)

include $(ENV)

# Export all variable to sub-make/shell
export

.PHONY: help venv install migrate startproject runserver django-shell db-up db-shell test coverage travis

.DEFAULT_GOAL := help

help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# -------------------------------------------------------------------------------------
# LOCAL DEV
# -------------------------------------------------------------------------------------

# Install Project
# -------------------------------------------------------------------------------------
venv: ## Make a new virtual environment
	# python3 -m venv $(VENV) && source $(BIN)/activate
	virtualenv -p python3.9 $(VENV) && source $(BIN)/activate
install: install-requirements install-pre-commit ## Install requirements and initiate pre-commit
install-requirements: venv ## Make venv and install local requirements
	$(BIN)/pip install -r requirements.txt
install-pre-commit:
	pre-commit install

migrate: ## Make migrate
	$(PYTHON) manage.py migrate

startproject: install migrate ## Install requirements, apply migrations

makemigrations: ## Make migrations
	$(PYTHON) manage.py makemigrations

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
	@echo "from django.contrib.auth import get_user_model;"\
		"User = get_user_model();" \
		"User.objects.create_superuser(*'$(DJANGO_DEV_ADMIN_LOCAL)'.split(':'))" \
		| $(PYTHON) manage.py shell

# Django
# -------------------------------------------------------------------------------------
django-shell: ## Run ipython in django shell
	$(PYTHON) manage.py shell -i ipython

runserver: ## Run the Django server
	$(PYTHON) manage.py runserver $(DJANGO_PORT)

# TEST
# -------------------------------------------------------------------------------------
test: coverage ## Run tests and make coverage report

coverage: ## Clear and run coverage report
	coverage erase
	coverage run -m pytest
	coverage report -m
	coverage html

