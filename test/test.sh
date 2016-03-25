#!/bin/bash
begin_path=`pwd`
path=../../deployer-tester
if [ ! -d "$path" ]; then cp -R deployer-tester $path; fi
cd $path
if [ ! -f "docker-compose.yml" ]; then . docker-compose-create; fi

if [ "$(uname)" == "Darwin" ];
  then
  echo "Docker machine active ?"
  docker-machine active
  if [ "$?" -ne 0 ] ;
    then
      echo "Starting docker-machine"
    docker-machine start default
  fi

  echo "Declaring docker-machine env"
  sleep 3
  eval $(docker-machine env default)
fi

container_running=`docker ps | grep c2is/debian-apache-php-fpm-ssh`
if [ "$container_running" == "" ] ;
  then
    docker stop $(docker ps -a -q); docker rm $(docker ps -a -q)
    docker-compose up -d
fi

host=`echo $DOCKER_HOST | cut -d/ -f3 | cut -d: -f1`

sed "s/host:.*$/host:$host/g" hosts.yml > hosts
mv hosts hosts.yml

echo "n" | deployer init
deployer test
deployer deploy
echo "y" | deployer -d deploy
deployer -s rollback
deployer rollback
echo "y" | deployer exec ls %deploy_to
