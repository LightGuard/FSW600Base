## fsw-docker
This project builds a [docker](http://www.docker.io) container for running [JBoss Fuse Service Works](http://http://www.redhat.com/products/jbossenterprisemiddleware/) 6.0.0.GA.

## Prerequisites
1. Install [Docker](https://www.docker.io/gettingstarted/#1)
2. Download JBoss Fuse Service Works from [jboss.org.](http://jboss.org/products/#IBP)
2. Put the downloaded file into fsw-docker/software
	
## Building the docker container locally
Once you have [installed docker](https://www.docker.io/gettingstarted/#h_installation) and downloaded the JBoss Fuse Service Works, you should be able to create the JBoss Fuse Service Works container via the following command:

If you are on OS X then see How to use [Docker on OS X.](https://github.com/fabric8io/fabric8-docker/blob/master/DockerOnOSX.md)

		$ docker build -t jbossfsw600 . 

The JBoss Fuse Service Works container then build.

## Try it out
If you have docker installed you should be able to try it out via:

		$ cd fsw-docker
		$ docker run -P -d -t jbossfsw600 

This will run the jbossfsw600 container and starts automatically JBoss FSW.  You can then run **docker attach $containerID** or **docker logs -f $containerID**  to get the logs at any time.	

Run **docker ps** to see all the running containers or **docker inspect $containerID** to view the IP address and details of a container.

## Experimenting
To spin up a shell in the JBoss Data Virtualization containers try:

		$ docker run -P -i -t jbossfsw600 /bin/bash

You can then noodle around the container and run stuff & look at files etc.

The /home/jboss/run.sh sript can be used to start JBoss Fuse Service Works 6.0.0.GA.
