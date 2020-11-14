#!/bin/sh
sleep 3
apt-get update
sleep 3
DEBIAN_FRONTEND=noninteractive apt-get install -y ruby-full ruby-bundler build-essential
