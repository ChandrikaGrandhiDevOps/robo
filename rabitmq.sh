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
    echo -e "$R ERROR:: FAILED" 
    
else
    echo -e "$G .....SUCCESS"
fi

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE
VALIDATE $? "link"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE
VALIDATE $? "link"

dnf install rabbitmq-server -y  &>> $LOGFILE
VALIDATE $? "rabit installed"

systemctl enable rabbitmq-server  &>> $LOGFILE
VALIDATE $? "enabeled"

systemctl start rabbitmq-server  &>> $LOGFILE
VALIDATE $? "staretd"

rabbitmqctl add_user roboshop roboshop123  &>> $LOGFILE
VALIDATE $? "creating user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE
VALIDATE $? "setting permission"

