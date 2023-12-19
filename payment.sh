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

dnf install python36 gcc python3-devel -y
VALIDATE $? "installed py"

id roboshop
 if [ $? -ne 0 ]
  then   
    useradd roboshop                        
    VALIDATE $? "created robo user"  
   else
    echo -e "alraedt exist $Y ....SKIPPING"    
 fi

 mkdir -p /app       &>> $LOGFILE
VALIDATE $? "created direcory"

curl -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOGFILE
VALIDATE $? "link " 

cd /app  &>> $LOGFILE
VALIDATE $? "directory"


unzip -o /tmp/payment.zip &>> $LOGFILE
VALIDATE $? "unzipped"

pip3.6 install -r requirements.txt &>> $LOGFILE
VALIDATE $? "installed"

cp /home/centos/robo/payment.service /etc/systemd/system/payment.service &>> $LOGFILE
VALIDATE $? "payment services"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "reloaded"

systemctl enable payment &>> $LOGFILE
VALIDATE $? "enabled payment"

systemctl start payment  &>> $LOGFILE
VALIDATE $? "started payment"