# REPO=blacktop/docker-ghidra
ORG=aseec
NAME=ghidra
BUILD ?=$(shell cat LATEST)
LATEST ?=$(shell cat LATEST)


all: build

build: start-docker ## Build docker image
	docker build -t $(ORG)/$(NAME):$(BUILD) $(BUILD)

.PHONY: start-docker
start-docker: ## Start Docker if not running
	@if ( ! docker version > /dev/null 2>&1 ); then		\
		while ( ! docker version > /dev/null 2>&1 ); do \
			sleep 1;									\
		done;											\
	fi
	@echo "Docker running!"

.PHONY: size
size: build ## Get built image size
ifeq "$(BUILD)" "$(LATEST)"
	sed -i.bu 's/docker%20image-.*-blue/docker%20image-$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(BUILD)| cut -d' ' -f1)-blue/' README.md
	sed -i.bu '/latest/ s/[0-9.]\{3,5\}MB/$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(BUILD))/' README.md
endif
	sed -i.bu '/$(BUILD)/ s/[0-9.]\{3,5\}MB/$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(BUILD))/' README.md

.PHONY: tags
tags:
	docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" $(ORG)/$(NAME)

.PHONY: tar
tar: ## Export tar of docker image
	docker save $(ORG)/$(NAME):$(BUILD) -o $(NAME).tar

.PHONY: run
run: stop-client ## Run ghidra client
	@docker run --init -it --name $(NAME) \
             --cpus="2" \
             --memory="4g" \
             -e MAXMEM=4G \
             -e DISPLAY=host.docker.internal:0 \
			 -v `pwd`:/samples \
             $(ORG)/$(NAME):$(BUILD)

.PHONY: socat
socat: ## Start socat
	open -a XQuartz
	socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$$DISPLAY\"

.PHONY: ssh
ssh: ## SSH into docker image
	@docker run --init -it --rm --entrypoint=bash -e DISPLAY=$(ipconfig getifaddr en0):0 $(ORG)/$(NAME):$(BUILD)

.PHONY: stop-client
stop-client: ## Kill running client container
	@docker rm -f $(NAME) || true

.PHONY: stop-server
stop-server: ## Kill running server container
	@docker rm -f $(NAME)-server || true

.PHONY: stop-all
stop-all: ## Kill ALL running docker containers
	@docker-clean stop

clean: stop-all ## Clean docker image and stop all running containers
	docker rmi $(ORG)/$(NAME):$(BUILD) || true

# Absolutely awesome: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help