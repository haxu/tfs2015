#!bin/bash

clear
echo "**********************TFS linux build agent pre-installation**********************"

echo "**********************Update First**********************"
apt-get update -y
apt-get upgrade -y
apt-get install -y vsftpd
echo "******************************************************************"
echo "**********************Starting gcc Install**********************"
echo "******************************************************************"
apt-get install -y gcc
apt-get install -y g++

echo "******************************************************************"
echo "**********************Starting Nodejs Install**********************"
echo "******************************************************************"
curl -sL https://deb.nodesource.com/setup | sudo bash -
apt-get install -y nodejs

echo "******************************************************************"
echo "**********************Starting Python Install**********************"
echo "******************************************************************"
apt-get install -y python-dev
apt-get install -y build-essential libssl-dev libevent-dev libjpeg-dev libxml2-dev libxslt-dev
apt-get install -y python-pip
sudo pip install virtualenv

echo "******************************************************************"
echo "**********************Starting Java Install**********************"
echo "******************************************************************"
apt-get install -y default-jre
apt-get install -y default-jdk
apt-get install -y ant
apt-get install -y maven

echo "******************************************************************"
echo "**********************Starting cmake Install**********************"
echo "******************************************************************"
apt-get install -y cmake

echo "******************************************************************"
echo "**********************Starting llvm Install**********************"
echo "******************************************************************"
apt-get install -y llvm

echo "******************************************************************"
echo "**********************Starting Git Install**********************"
echo "******************************************************************"
apt-get install -y git
apt-get install -y vim

echo "******************************************************************"
echo "**********************Starting Gulp Install**********************"
echo "******************************************************************"
npm install --global gulp
npm install --save-dev gulp

echo "******************************************************************"
echo "**********************Starting wget Install**********************"
echo "******************************************************************"
apt-get install -y wget
apt-get install -y curl

echo "******************************************************************"
echo "**********************Starting vsoagent Install**********************"
echo "******************************************************************"

npm install vsoagent-installer -g
echo "**********************Done**********************"
