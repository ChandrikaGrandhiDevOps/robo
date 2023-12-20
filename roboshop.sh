#!/bin/bash

AMI=ami-03265a0778a880afb
SG_ID=sg-0d9d67af01c6a1199 
INSTANCES=("mongodb" "redis" "mysql" "user" "cart" "payment" "shipping" "dispatch" "catalogue" "web")

for i in "${INSTANCES[@]}"
do
    if [ $i == "mongodb" ]||[ $i == "mysql" ]||[ $i == "shipping" ]
      then 
         INSTANCE_TYPE="t3.small"
       else
        INSTANCE_TYPE="t2.micro"
    fi

IP_ADDRESS=$(aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-0d9d67af01c6a1199 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)
echo "$i: $IP_ADDRESS"
done