
.PHONY: up clean reset

all: stop up

up:
	docker-compose up --build -d

stop:
	docker-compose stop

interactive: stop
	docker-compose up --build

clean:
	rm -rf ./app/* && rm -rf ./db/data/*

reset: stop clean
	git reset head --hard
