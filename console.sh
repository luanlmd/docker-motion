#!/bin/bash

function init
{
    docker pull ubuntu:zesty
    build
}

function build
{
    docker build -t motion .
    run
}

function run
{
    docker run -v $(pwd)/data:/data -v $(pwd)/conf.d:/conf.d -v $(pwd)/log:/var/log/motion -d --restart=always motion
}

function ssh
{
	docker exec -i -t $(docker ps -qf ancestor=motion) /bin/bash -c "export TERM=xterm; exec bash"
}

function stop
{
	docker stop $(docker ps -qf ancestor=motion)
}

function restart
{
	docker restart $(docker ps -qf ancestor=motion)
}

function clear
{
	IDs=$(docker ps -a -q -f "status=exited")
	if [ -n "$IDs" ]; then
		docker rm $IDs
	fi

	IDs=$(docker images -q -f dangling=true)
	if [ -n "$IDs" ]; then
		docker rmi 
	fi
}

mkdir -p data
chmod 777 data
mkdir -p log
chmod 777 log

$1
