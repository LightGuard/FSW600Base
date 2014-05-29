#!/usr/bin/env bash
if [ -f "software/jboss-fsw-installer-6.0.0.GA-redhat-4.jar" ]
then
        
	echo "Building the JBoss Fuse Service Works 6.0.0 container"
	docker build -t jbossfsw600 .
else
	echo "File software/jboss-fsw-installer-6.0.0.GA-redhat-4.jar not found."
        echo "Please download JBoss Fuse Service Works 6.0.0.GA from http://jboss.org/products#IBP"
        exit 0
fi
