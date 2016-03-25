Start docker containers
docker-compose up -d

Macosx :
docker-machine start default
eval $(docker-machine env default)

To perform some commands onto a container :
docker exec [HASH_CONTAINER] ls /var/www/
