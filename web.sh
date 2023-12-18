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
        echo -e "$R ERROR:: $2 ....FAILED" &>> $LOGFILE
        exit 1
    else
        echo -e "$G $2 .....SUCCESS $N"
    fi
}
if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: FAILED" &>> $LOGFILE
    
else
    echo -e "$R i was sucessfully installed"
fi
dnf install nginx -y
VALIDATE $? "nginx installed"

systemctl enable nginx
VALIDATE $? "enabled nginx"

systemctl start nginx
VALIDATE $? "started nginx"

rm -rf /usr/share/nginx/html/*
VALIDATE $? "removed"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip
VALIDATE $? "zip file"

cd /usr/share/nginx/html
VALIDATE $? "goto html"

unzip /tmp/web.zip
VALIDATE $? "unzipped"

cp /home/centos/robo/roboshop.conf /etc/nginx/default.d/roboshop.conf 
VALIDATE $? "copied"

systemctl restart nginx 
VALIDATE $? "restarted"