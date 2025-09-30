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


usage(){
    echo " Script USAGE : <SOURCED> <DESTD> <DAYS-OPTIONAL>"
}

if [ $# -lt 2 ]; then 
    usage
    exit 1
fi

#SOURCE_DIR=/home/ec2-user/shell-roboshop/app-logs
SOURCE_DIR=$1
DESTD=$2
DAYS=${3:-14}


if [ ! -d $SOURCE_DIR ]; then
    echo "ERROR in directory"
    exit 1 
fi

FILES=$(find $SOURCE_DIR -name *.log -mtime +$DAYS)
if [ ! -z "$FILES" ]; then 
        DATE=$(date +%F-%H-%M)
        ZIPFILE=$DESTD/app-log-$DATE
        echo $FILES| zip -@ -j $ZIPFILE.$DATE
        if [ $? -ne 0 ];then
            echo "error is zipping"
        else
            echo "ZIP SUCUESS"
        #echo " deleting the files ::::$filepath"
else 
    echo "NO ARCHIVE"
fi