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
        echo -e "$G  $2 i was installed it suceesesfully $N"
    fi
}
if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: FAILED" &>> $LOGFILE
    
else
    echo -e "$R i was sucessfully installed"
fi
dnf module disable nodejs -y            &>> $LOGFILE
VALIDATE $? "Sucessfully disabeled"

dnf module enable nodejs:18 -y          &>> $LOGFILE
VALIDATE $? "Sucessfullly enabeled"
 
dnf install nodejs -y                   &>> $LOGFILE
VALIDATE $? "sucessfully installed"

id roboshop
if [ $? -ne 0 ]
then   
    useradd roboshop                        &>> $LOGFILE
    VALIDATE $? "created robo user"  
else
    echo -e "alraedt exist $Y ....SKIPPING)       

mkdir -p /app         &>> $LOGFILE
VALIDTAE $? "created direcory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE
VALIDTAE $? "link " 

cd /app  &>> $LOGFILE


unzip -o /tmp/catalogue.zip &>> $LOGFILE
VALIDTAE $? "unzipped" 

npm install &>> $LOGFILE
VALIDTAE $? "installled " 

cp /home/centos/robo/catalogue.service /etc/systemd/system/  &>> $LOGFILE
VALIDATE $? "service file"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "reloaded" 

systemctl enable catalogue &>> $LOGFILE
VALIDATE $? "enabeled" 

systemctl start catalogue &>> $LOGFILE
VALIDATE $? "started" 

cp /home/cewntos/robo/mongodb.repo /etc/yum.repos.d/ &>> $LOGFILE
VALIDATE $? "started" 

dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "install" 

mongo --host mongodb.crobo.shop</app/schema/catalogue.js &>> $LOGFILE
VALIDATE $? "mongo host" 
