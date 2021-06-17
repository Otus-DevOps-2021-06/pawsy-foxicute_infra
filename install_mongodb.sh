#!/bin/bash

#1
cd
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list

#2
sudo apt-get update
sudo apt-get install -y mongodb-org

#3
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod

#4
sudo apt -y install git
cd
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
ps aux | grep puma
