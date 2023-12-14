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

useradd roboshop                        &>> $LOGFILE
VALIDATE $? "created robo user"     

mkdir /app         &>> $LOGFILE
VALIDTAE $? "created direcory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
VALIDTAE $? "link " &>> $LOGFILE

cd /app 
VALIDTAE $? "app dire" &>> $LOGFILE

unzip /tmp/catalogue.zip
VALIDTAE $? "unzipped" &>> $LOGFILE

npm install 
VALIDTAE $? "installled " &>> $LOGFILE

cp /home/centos/robo/catalogue.service /etc/systemd/system/ 
VALIDATE $? "service file" &>> $LOGFILE

systemctl daemon-reload
VALIDATE $? "reloaded" &>> $LOGFILE

systemctl enable catalogue
VALIDATE $? "enabeled" &>> $LOGFILE

systemctl start catalogue
VALIDATE $? "started" &>> $LOGFILE
