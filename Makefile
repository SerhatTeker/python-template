# Makefile for YADRTA Projects
SHELL := /bin/bash

# Variables
# -------------------------------------------------------------------------------------

# Variables
# -------------------------------------------------------------------------------------
ROOT_DIR 	:= $(PWD)
MAKE_DIR 	:= $(ROOT_DIR)
VENV		:= $(ROOT_DIR)/.venv
ENV			:= $(ROOT_DIR)/.env
BIN			:= $(VENV)/bin
PYTHON3		:= $(BIN)/python3
PYTHON		:= $(PYTHON3)
DJANGO_DIR	:= $(ROOT_DIR)/django

include $(ENV)

# Export all variable to sub-make/shell
export

.PHONY: help venv install install-requirements install-pre-commit

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

# Django
# -------------------------------------------------------------------------------------
django-help: ## Help for Django targets
	@$(MAKE) -C $(DJANGO_DIR) help

django-setup: ## Setup Django Project
	@echo "Staring Django Setup"
	@$(MAKE) -C $(DJANGO_DIR) startproject

django-run: ## Run the Django server
	@$(MAKE) -C $(DJANGO_DIR) runserver

django-shell: ## Run ipython in django shell
	@$(MAKE) -C $(DJANGO_DIR) runserver

django-test: ## Run tests and make coverage report
	@$(MAKE) -C $(DJANGO_DIR) test

django-clean: ## Clean django-setup
	@$(MAKE) -C $(DJANGO_DIR) clean
