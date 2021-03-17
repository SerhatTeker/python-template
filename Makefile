# -------------------------------------------------------------------------------------
# Local Dev for Python Projects
# Author : Serhat Teker <serhat.teker@gmail.com>
# -------------------------------------------------------------------------------------
SHELL := /bin/bash

# Variables
# -------------------------------------------------------------------------------------
ROOT_DIR		:= $(PWD)
MAKE_DIR		:= $(ROOT_DIR)
# Python version to create virtual environment with
PYTHON_VERSION	?= python3.9
VENV			:= $(ROOT_DIR)/.venv
ENV				:= $(ROOT_DIR)/.env
BIN				:= $(VENV)/bin
PYTHON3			:= $(BIN)/python3
PYTHON			:= $(PYTHON3)

include $(ENV)

# Export all variable to sub-make/shell
export

.PHONY: help setup install-requirements venv install-pre-commit

.DEFAULT_GOAL := help

help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Setup Project
# -------------------------------------------------------------------------------------
setup: install-requirements install-pre-commit ## Install requirements and initiate pre-commit

install-requirements: venv ## Make venv and install local requirements
	$(BIN)/pip install -r requirements.txt

venv: ## Make a new virtual environment
	# python3 -m venv $(VENV) && source $(BIN)/activate
	virtualenv -p $(PYTHON_VERSION) $(VENV) && source $(BIN)/activate

install-pre-commit:
	pre-commit install
