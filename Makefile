#
#  Makefile for Redis Slave
#

APP_NAME=redis-slave

.PHONY: all build 

all: build

build: 
	docker build -f Dockerfile -t registry.prod.kairos.com/$(APP_NAME):latest .

