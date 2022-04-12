#!/bin/bash



# Backup Jenkins Files From Container

DATE=$(date "+%b-%d-%Y-%H-%M-%S") 

docker cp jenkins:/var/jenkins_home/ /var/vardot/jenkins/jenkins_files_${DATE}

export AWS_ACCESS_KEY=$1
export AWS_SECRET_KEY=$2

echo "upload jenkins files backups to S3..."

aws s3 sync /var/vardot/jenkins/ s3://<backet-name>/dir_backups/

if [ $? -eq 0 ]; then
	echo "Upload to S3 is SUCCSSFULLY!"
	exit 0;
else
	echo "Upload to S3 is FAILED!"
fi
echo "compeleted."
