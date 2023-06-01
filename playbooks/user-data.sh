#!/bin/bash -x

yum update -y
yum install -y git wget

# Install Docker
wget -qO- get.docker.com | sh &
wait
service docker start

# Start Codespaces
cd /root
git clone https://github.com/codespaces-io/codespaces.git
curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
cd /root/codespaces/cs-chef-ci
docker-compose up -d
