image:
	docker-compose build

run:
	docker-compose up -d

all: image run
