#!/bin/bash
apt-get update -y

killall apt apt-get
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock*

apt-get install -y ruby-full ruby-bundler build-essential

ruby -v
bundler -v
