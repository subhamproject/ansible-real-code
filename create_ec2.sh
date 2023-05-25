#!/bin/bash

COUNT=$1
AMI=$2

[ -z $COUNT ] && { echo "Please provide number of instance you wish to start as first arg - and try again " ; exit 1 ; }
[ -z $AMI ] && { echo "Please provide AMI you wish to start Server for as second arg - and try again " ; exit 1 ; }

case $AMI in
ubuntu)
export IMAGE="ami-0fcf52bcf5db7b003"
export AMI=${AMI^}
;;
*)
export IMAGE="ami-01acac09adf473073"
export AMI=${AMI^}
;;
esac

if [[ $(aws ec2 describe-security-groups |grep public-ssh-sg|wc -l) -lt 1 ]];then 
SG=$(aws ec2 create-security-group --description "Allow ssh access over the internet" --group-name "public-ssh-sg"  --output text) > /dev/null 2>&1
else
SG=$(aws ec2 describe-security-groups --output text |grep public-ssh-sg |awk -F" " '{print $8}')
fi

aws ec2 authorize-security-group-ingress --group-id "$SG" --protocol "tcp" --port "22" --cidr "0.0.0.0/0"  > /dev/null 2>&1

echo "Creating $COUNT $AMI ec2 machines"
aws ec2 run-instances --image-id $IMAGE --count $COUNT --security-group-ids $SG --instance-type t2.micro --key-name Devops --block-device-mappings "[{\"DeviceName\":\"/dev/xvdf\",\"Ebs\":{\"VolumeSize\":10,\"DeleteOnTermination\":true}}]" --associate-public-ip-address --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$AMI Demo server}]" "ResourceType=volume,Tags=[{Key=Name,Value=$AMI Demo serverdisk}]" > /dev/null 2>&1
[ $? -eq 0 ] && echo "Instance has been created please check in console" || echo "There is some issue please check"
