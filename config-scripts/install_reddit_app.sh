#!/bin/sh

# Install ruby
apt update
apt install -y ruby-full ruby-bundler build-essential

# Install mongodb
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list

apt update
apt install -y mongodb-org

sudo systemctl start mongod
sudo systemctl enable mongod

# Install reddit app
apt install git -y
git clone -b monolith https://github.com/express42/reddit.git
cd reddit
bundle install

sudo -u ubuntu puma -d
