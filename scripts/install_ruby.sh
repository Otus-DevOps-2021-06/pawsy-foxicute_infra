#!/bin/bash
sudo apt -y update
sudo apt -y install -y ruby-full ruby-bundler build-essential
ruby -v
bundler -v
