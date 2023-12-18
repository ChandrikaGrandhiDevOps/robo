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
        echo -e "$G $2 ...........SUCCESS $N"
fi
}
if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: FAILED" &>> $LOGFILE
    
else
    echo -e "$G .....SUCCESS"
fi

dnf module disable mysql -y
VALIDATE $? "disabeld"

cp /home/centos/robo/mysql.repo /etc/yum.repos.d/mysql.repo
VALIDATE $? "copied"

dnf install mysql-community-server -y
VALIDATE $? "installled"


systemctl enable mysqld
VALIDATE $? "enabled"



systemctl start mysqld
VALIDATE $? "started"


mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "installed"
