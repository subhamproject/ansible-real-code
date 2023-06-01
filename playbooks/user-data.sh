#!/bin/bash -x

yum update -y
yum install -y git wget httpd
sleep 5
systemctl enable httpd
systemctl start httpd

echo 'Hello World!' >> /var/www/html/index.html
