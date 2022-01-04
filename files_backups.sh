#!/bin/bash

DATE=$(date "+%d-%m-%Y-%H-%M-%S")
HOME_USER=$1
AWS_ACCESS_KEY=$2
AWS_SECRET_KEY=$3
DIRFILES="/home/${HOME_USER}/public_html/sites/default/"

DIRBACKUPS="/var/vardot/backups/${HOME_USER}"
sleep 3
if [ ! -d $DIRBACKUPS ]; then
       mkdir -p $DIRBACKUPS && cd $DIRFILES && tar -zcvf /var/vardot/backups/${HOME_USER}/${HOME_USER}_files_${DATE}.tar.gz  files/ > /dev/null
       exit 0
    else 	
	echo "FAUILED!!!"
	exit 1
fi