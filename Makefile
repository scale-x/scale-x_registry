# help by https://makefiletutorial.com/
# successeful example https://itnext.io/docker-makefile-x-ops-sharing-infra-as-code-parts-ea6fa0d22946
# all our targets are phony (no files to check)
.PHONY: help build start stop

	help:
		@echo ''
		@echo 'Usage: make [TARGET] [OPTIONS]?'
		@echo 'Targets:'
		@echo '	build		build docker containers'
		@echo '	start		start containers'
		@echo '	stop		stop containers'
		@echo '	sh		attach to container shell c=auth|quizdb|authdb|graphql default=auth'
		@echo '					example: make c=backend sh'
		@echo '	log		attach to container stdout,stderr c=auth|quizdb|authdb|graphql default=auth'
		@echo '					example: make c=auth log'
		@echo ''

USER_ID := $(shell id -u)
USER_NAME := $(shell id -un)
GROUP_ID := $(shell id -g)
GROUP_NAME := $(shell id -gn)
PROJECT_DIR := $(shell pwd)
HOME_DIR := $(shell echo "${HOME}")
export USER_ID
export USER_NAME
export GROUP_ID
export GROUP_NAME
export PROJECT_DIR
export HOME_DIR

_install-auth:
	docker compose run auth dart pub get

_build:
	docker compose build --no-cache

build: _build _install-auth

start:
	docker compose up -d --remove-orphans

stop: 
	docker compose down

c = auth
sh:
	docker compose exec $(c) sh

log:
	docker compose logs -f $(c)


