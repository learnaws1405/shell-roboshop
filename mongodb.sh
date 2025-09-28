#! /sbin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


LOG_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0| cut -d "." -f1 )
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"


if [ $USERID -ne 0 ]; then 
 echo "Install with root user"
 exit 1
fi

mkdir -p $LOG_FOLDER
echo " Script started : $(date)" | tee -a $LOG_FILE

VALIDATE(){
if [ $1 -ne 0 ]; then 
 echo -e "Install of $2 is $R FAILURE $N" | tee -a $LOG_FILE
else
 echo -e "Install of $2 is  $G SUCCESS $N" | tee -a $LOG_FILE
fi
}

cp mango.repo /etc/yum.repos.d/mongo.repo
VALIDATE "$?" "Adding MongoDB repository"

echo " Installing Mango BD"

dnf install mongodb-org -y 
VALIDATE "$?" "MongoDB"

systemctl enable mongod
VALIDATE "$?" "MongoDB system enabled"

systemctl start mongod
VALIDATE "$?" "MongoDB system started"