#!/bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

MONGODB_HOST=mongodb.crobo.shop

TIMESTAMP=$(date +%F-%H-%M-%S)

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
dnf module disable nodejs -y            &>> $LOGFILE
VALIDATE $? "Sucessfully disabeled"

dnf module enable nodejs:18 -y          &>> $LOGFILE
VALIDATE $? "Sucessfullly enabeled"
 
dnf install nodejs -y                   &>> $LOGFILE
VALIDATE $? "sucessfully installed"

id roboshop
 if [ $? -ne 0 ]
  then   
    useradd roboshop                        
    VALIDATE $? "created robo user"  
   else
    echo -e "alraedt exist $Y ....SKIPPING"    
 fi

mkdir -p /app       
VALIDATE $? "created direcory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE

VALIDATE $? "downloaded file"

cd /app  &>> $LOGFILE
VALIDATE $? "vali"

unzip -o /tmp/user.zip &>> $LOGFILE

VALIDATE $? "unzipping the file"

npm install  &>> $LOGFILE

VALIDATE $? "instaling NPM"

cp /home/centos/robo/user.service /etc/systemd/system/user.service &>> $LOGFILE
VALIDATE $? "copied"

systemctl daemon-reload

VALIDATE $? "reloaded"

systemctl enable user 

VALIDATE $? "enabeled"

systemctl start user

VALIDATE $? "started"

cp /home/centos/robo/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "copying the mogo.repo file"

dnf install mongodb-org-shell -y

VALIDATE $? "installing org shell"

mongo --host $MONGODB_HOST </app/schema/user.js

VALIDATE $? "loading the data into user"

