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
        echo -e "$R $2 i was installed it suceesesfully $N"
    fi
}
if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: FAILED" 
    
else
    echo -e "$R i was sucessfully installed"
fi

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE

VALIDATE $? "installing rpm"  

dnf module enable redis:remi-6.2 -y &>> $LOGFILE

VALIDATE $? "enabling redis" 

dnf install redis -y  &>> $LOGFILE

VALIDATE $? " install redis" 

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf  &>> $LOGFILE

VALIDATE $? "validate connections" 

systemctl enable redis &>> $LOGFILE

VALIDATE $? "enabeled redis" 

systemctl start redis &>> $LOGFILE

VALIDATE $? "started redis" 