#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGFILE="/tmp/$0-$TIMESTAMP.log"
exec &>> $LOGFILE

echo "Script started executing at $TIMESTAMP" 

VALIDATE(){
 if [ $1 -ne 0 ]
    then
        echo -e "$R ERROR:: $2 FAILED" 
    else
        echo -e "$Y $2 i was installed it suceesesfully $N"
    fi
}
if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: FAILED" 
    
else
    echo -e "$R i was sucessfully installed"
fi
dnf module disable nodejs -y            
VALIDATE $? "Sucessfully disabeled"

dnf module enable nodejs:18 -y          
VALIDATE $? "Sucessfullly enabeled"
 
dnf install nodejs -y                   
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

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE
VALIDATE $? "link " 

cd /app  


unzip -o /tmp/cart.zip 
VALIDATE $? "unzipped"  
 
npm install 
VALIDATE $? "installled" 

cp /home/centos/robo/cart.service /etc/systemd/system/cart.service
VALIDATE $? "copied service file"  &>> $LOGFILE

systemctl daemon-reload 
VALIDATE $? "reloaded" 

systemctl enable cart 
VALIDATE $? "enabeled" 

systemctl start cart 
VALIDATE $? "started"




