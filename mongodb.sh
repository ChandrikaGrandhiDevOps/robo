#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
 if [ $1 -ne 0 ]
    then
        echo -e "$R ERROR:: $2 FAILED"
        exit 1
    else
        echo -e "$G  $2 i was installed it suceesesfully $N"
fi
}
if [ $ID -ne 0 ]
 then
    echo -e "$R ERROR:: FAILED"
    exit 1
 else
    echo -e "$R i was sucessfully installed"
fi

cp /home/centos/robo/mongo.repo /etc/yum.repos.d/mongo.repo 

VALIDATE $? "copied MONGODB repo sucessfully"

dnf install mongodb-org -y 

VALIDATE $? "installed"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "enabeled"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "started"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "modi"

systemctl restart mongod

VALIDATE $? "restarted"