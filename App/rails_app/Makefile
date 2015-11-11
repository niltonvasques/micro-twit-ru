all: setup deploy

setup:
	echo "Creating postgre container..."		
	docker run --name postgres-container -e POSTGRES_PASSWORD=micro-ru-pwd -d postgres

deploy:
	docker build -t micro-ru-image .
	sudo docker stop micro-ru-container
	sudo docker rm micro-ru-container
	sudo docker run --name micro-ru-container --link postgres-container:postgres -p 3000:3000 -d micro-ru-image

bash:
	sudo docker exec -it micro-ru-container bash
