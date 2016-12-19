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
	docker run -v $(pwd)/data:/data -v $(pwd)/conf.d:/conf.d -v $(pwd)/log:/var/log/motion -d --restart=always motion > container.pid
}

function ssh
{
	docker exec -i -t $(< container.pid) /bin/bash -c "export TERM=xterm; exec bash"
}

function stop
{
	if [ -f "container.pid" ]; then
		docker stop $(< container.pid)
		docker rm $(< container.pid)
		rm container.pid
	fi
}

function restart
{
	stop
	run
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
