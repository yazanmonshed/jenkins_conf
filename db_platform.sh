#!/bin/bash

#ENV Varabiels 

PROJECTID=$1
PROJECTBRANCH=$2
ACCESS_KEY=$3
SECRET_KEY=$4
DIR_PROJECT=$5
DATE=$(date "+%d-%m-%Y-%H-%M-%S")

DIR="/var/vardot/backups/${DIR_PROJECT}"
echo "check if $DIR exsits..."
if [ ! -d $DIR ]; then
	
	mkdir -p ${DIR}
fi

echo "start dumping database..."
platform db:dump --gzip --project $PROJECTID --environment $PROJECTBRANCH -z -y --file=db_${PROJECTID}_${DATE}.sql.gz --directory=/var/vardot/backups/$DIR_PROJECT/ 
if [ $? -eq 0 ]; then
	echo "database dump is SECCESSFULY!!"
else
	echo "dump database is FAILED!!!"
	exit 1
fi

echo "database dump is completed."

export  AWS_ACCESS_KEY=$ACCESS_KEY
export AWS_SECRET_KEY=$SECRET_KEY

echo "uploading backups to aws S3..."
	
aws s3 sync /var/vardot/backups/$DIR_PROJECT/ s3://vardot-backups/platform.sh/$DIR_PROJECT/

if [ $? -eq 0 ]; then
	echo "upload databases backups to AWS S3 IS SECESSFULLY!!"
else
	echo "upload databases backups is FAUILED!!!"
	exit 1
fi

echo "upload platform.sh databases backups is compeleted..."


echo "remove backup after upload to S3..."

#find /var/vardot/backups/$DIR_PROJECT/*.sql.gz -mtime +3 -exec rm {} \;

sleep 10
find /var/vardot/backups/$DIR_PROJECT/*.sql.gz -exec rm {} \;

if [ $? -eq 0 ]; then
	echo "deleted databases backups is SECESSFULLY!!!"
else
	echo "upload databases backups is FAUILED!!!"
	exit 1
fi

echo "finshed deleted backups."
echo "test tag working good"
#cd /home/jenkins/bckups/$DIR_PROJECT/ && rm -rf * 
