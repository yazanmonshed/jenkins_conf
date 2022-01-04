#!/bin/bash

#Date Dump Database

#DBDATE=$(date "+%b-%d-%Y-%H-%M-%S") 

# call by value variables
DBUSER=$1
DBPASS=$2
DBNAME=$3   
AWS_ACCESS_KEY=$4
AWS_SECRET_KEY=$5
JOB_NAME=$6

DIR="/var/vardot/backups/${JOB_NAME}"

echo "check if $DIR exsists..."

#[[ -d $DIR ]] || { echo "$DIR not found...creating..."; mkdir -p $DIR }

if [ ! -d $DIR ]; then 

  echo "$DIR not found...creating..."
  mkdir -p ${DIR} 
fi 

sleep 3
echo "starting dump database..."

mysqldump -u $DBUSER -p${DBPASS} $DBNAME  | gzip > /var/vardot/backups/$JOB_NAME/db_${JOB_NAME}_$(date "+%d-%m-%Y-%H-%M-%S").sql.gz

if [ $? = 0 ]; then
   
   echo "database dumpi ${DBNAME} is SECESSFULLY!!"
else 
  echo "dump database ${DBNAME} FAILED!!"
  exit 1
fi
export AWS_ACCESS_KEY=$AWS_ACCESS_KEY
export AWS_SECRET_KEY=$AWS_SECRET_KEY

echo "uploading backups to AWS S3 Bucket..."


aws s3 sync /var/vardot/backups/$JOB_NAME/ s3://vardot-backups/ovh_backups/db/$JOB_NAME/

if [ $? = 0 ]; then 

   echo " Upload Database is SECESSFULLY!!" 

else
   echo "Upload Databases is FAILED!!" 
   exit 1;

fi
echo "upload backup database to S3 Completed."

echo "delete backups databases older then day ago..."

#find /var/vardot/backups/$JOB_NAME/*.sql.gz -mtime +1 -exec rm {} \;
sleep 10
find /var/vardot/backups/$JOB_NAME/*.sql.gz  -exec rm {} \;

if [ $? = 0 ]; then 
 
   echo "deleted backups ${JOB_NAME} is SECESSFULLY!!" 

else 

   echo "deleted backups for ${JOB_NAME} is FAILED!!"
   exit 1
fi 

echo "finshed deleted."