#!/bin/bash

echo "Updating package index..."
sudo apt update -y

echo "Installing required packages: git, OpenJDK 17, Maven, curl, wget, unzip, bash..."
sudo apt install -y git openjdk-17-jdk maven curl wget unzip bash

echo "Downloading latest stable Jenkins WAR file..."
wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war

echo "Installing font packages required for Jenkins UI..."
sudo apt install -y fontconfig fonts-dejavu-core

echo "Starting Jenkins in background with logs written to jenkins.log..."
nohup java -jar jenkins.war --httpPort=8080 > jenkins.log 2>&1 &

echo "Jenkins is starting... Tail the log with: tail -f jenkins.log"
