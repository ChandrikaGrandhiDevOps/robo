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

dnf install maven -y
VALIDATE $? "installed maven"

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

curl -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOGFILE
VALIDATE $? "link " 

cd /app  &>> $LOGFILE
VALIDATE $? "directory"


unzip -o /tmp/shipping.zip &>> $LOGFILE
VALIDATE $? "unzipped" 

mvn clean package &>> $LOGFILE
VALIDATE $? "installled " 

mv target/shipping-1.0.jar shipping.jar


cp /home/centos/robo/shipping.service /etc/systemd/system/shipping.service
VALIDATE $? "copied"

systemctl daemon-reload
VALIDATE $? "reloaded"

systemctl enable shipping 
VALIDATE $? "enabled ship"

systemctl start shipping
VALIDATE $? "started shipping"


dnf install mysql -y
VALIDATE $? "installed mysql"


mysql -h <mysql.crobo.sql> -uroot -pRoboShop@1 < /app/schema/shipping.sql 
VALIDATE $? "schemas"


systemctl restart shipping
VALIDATE $? "restarted"


