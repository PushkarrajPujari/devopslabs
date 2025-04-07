#!/bin/sh

echo "Updating package index..."
apk update

echo "Installing required packages: git, OpenJDK 17, Maven, curl, wget, unzip, bash..."
apk add git openjdk17 maven curl wget unzip bash

echo "Downloading latest stable Jenkins WAR file..."
wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war

echo "Installing font packages required for Jenkins UI..."
apk add --no-cache fontconfig ttf-dejavu

echo "Starting Jenkins in background with logs written to jenkins.log..."
nohup java -jar jenkins.war --httpPort=8080 > jenkins.log 2>&1 &

echo "Jenkins is starting... Tail the log with: tail -f jenkins.log"
