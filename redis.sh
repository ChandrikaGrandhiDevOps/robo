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
        echo -e "$R ERROR:: $2 FAILED" &>> $LOGFILE
        exit 1
    else
        echo -e "$R $2 i was installed it suceesesfully $N"
    fi
}
if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: FAILED" &>> $LOGFILE
    
else
    echo -e "$R i was sucessfully installed"
fi

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

VALIDATE $? "installing rpm" &>> $LOGFILE

dnf module enable redis:remi-6.2 -y

VALIDATE $? "enabling redis" &>> $LOGFILE

dnf install redis -y

VALIDATE $? " install redis" &>> $LOGFILE



sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf 

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf

VALIDATE $? "validate connections" &>> $LOGFILE

systemctl enable redis

VALIDATE $? "enabeled redis" &>> $LOGFILE

systemctl start redis

VALIDATE $? "started redis" &>> $LOGFILE