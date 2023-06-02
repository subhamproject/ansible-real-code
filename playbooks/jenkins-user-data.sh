#!/bin/bash -x

sudo yum install git wget -y
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jenkins-2.387.2-1.1.noarch -y   #2.387.2-1.1 
sudo amazon-linux-extras install nginx1 -y
sudo systemctl enable jenkins
sudo systemctl enable nginx
sudo systemctl start jenkins
sudo systemctl start nginx


#sudo yum --showduplicates list jenkins | expand
