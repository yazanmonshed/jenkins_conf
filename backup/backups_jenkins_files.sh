#!/bin/bash



# backups jenkins files from container

DATE=$(date "+%b-%d-%Y-%H-%M-%S") 




echo "start jenkins files backups"


docker cp jenkins:/var/jenkins_home/ /var/vardot/jenkins/jenkins_files_${DATE}

export AWS_ACCESS_KEY=$1
export AWS_SECRET_KEY=$2

echo "upload jenkins files backups to S3..."

aws s3 sync /var/vardot/jenkins/ s3://vardot-backups/ovh_backups/jenkins/backups_jenkins_conf/

if [ $? -eq 0 ]; then
	echo "upload to s3 is SESSFULLY!!"
	exit 0;
else
	echo "upload to s3 is FAUILED!!!"
fi
echo "fhinshed."
