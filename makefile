.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

init: ## Install package dependencies
	cp .env-example .env
	pip install --upgrade pip
	# install test project and package dependencies
	pip install -r requirements.txt
	# install package and dev dependencies (see setup.py)
	pip install '.[dev]'
test: ## Run package tests
	python -m pytest tests
ci: ## [CI] Run package tests and lint
	make test
	make lint
lint: ## Run code linting
	python -m flake8 .
format: ## Format code with Black
	black .
coverage: ## Run package tests and upload coverage reports
	python -m pytest --cov-report term --cov-report xml --cov=src/masonite/lang tests
publish: ## Publish package to pypi
	python setup.py sdist bdist_wheel
	twine upload dist/*
	rm -fr build dist .egg src/masonite_lang.egg-info
pypirc: ## Copy the template .pypirc in the repo to your home directory
	cp .pypirc ~/.pypirc