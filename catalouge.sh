
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGODBHOST="mongodb.daws86s.fun"
SCRIPT_L=$PWD
LOG_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0| cut -d "." -f1 )
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"


if [ $USERID -ne 0 ]; then 
 echo "Install with root user"
 exit 1
fi

mkdir -p $LOG_FOLDER
echo " Script started : $(date)" 

VALIDATE(){
if [ $1 -ne 0 ]; then 
 echo -e "Install of $2 is $R FAILURE $N" | tee -a $LOG_FILE
else
 echo -e "Install of $2 is  $G SUCCESS $N" | tee -a $LOG_FILE
fi
}

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE "$?" "NodeJS lower version disabled"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE "$?" "NodeJS 20 version enabled"

dnf install nodejs -y &>>$LOG_FILE
VALIDATE "$?" "NodeJS 20 version installed"

id roboshop
if [ $? -ne 0 ]; then 
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
    VALIDATE "$?" "user created"
else
    echo -e "user aready created ::$Y SKIPPING $N"
fi

mkdir -p /app   
VALIDATE "$?" "Binary directory created"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip
VALIDATE "$?" "Binaries downloaded"

cd /app
VALIDATE "$?" "changed directory"

rm -rf /app/*
unzip /tmp/catalogue.zip
VALIDATE "$?" "Unzipped bainaries"

cd /app
VALIDATE "$?" "changed directory"

npm install &>>$LOG_FILE
VALIDATE "$?" "installed dependecies"

cp $SCRIPT_L/catalogue.repo /etc/systemd/system/catalogue.service
VALIDATE "$?" "Systemctl added"

systemctl daemon-reload
VALIDATE "$?" "daemon reload"

systemctl enable catalogue &>>$LOG_FILE
VALIDATE "$?" "systemctl enabled"

systemctl start catalogue
VALIDATE "$?" "systemctl started nodejs applciation"

systemctl status catalogue
if [ $? -ne 0 ]; then 
   echo "PROBLEM in starting the service"
   exit 1
fi

cp $SCRIPT_L/mongoclient.repo /etc/yum.repos.d/mongo.repo
VALIDATE "$?" "mongoclient repo added"

dnf install mongodb-mongosh -y
VALIDATE "$?" "mongoclient installed"



INDEX=$(mongosh mmongodb.dlearnaws.fun --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $INDEX -lt 0 ]; then
 mongosh --host mongodb.dlearnaws.fun </app/db/master-data.js
 VALIDATE "$?" "loading master data to mongoDB"
else
 echo "Master Data already loaded :: $Y SKIPPING $N"
fi

# /etc/systemd/system/catalogue.service
# mongosh $MONGODBHOST --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')"