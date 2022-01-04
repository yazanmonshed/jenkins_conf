#!/bin/sh

#cd /home/kb/public_html

#VALUES HOME
HOME_USER=$1

HOME_DIR="/home/${HOME_USER}/public_html"
echo "check if dir ${HOME_USER} exists"
sleep 3
echo "chanage directory to home ${HOME_USER}..."
cd $HOME_DIR

if [ ! -d $HOME_DIR ]; then
    echo "user home ${HOME_USER} is exists" 
fi

echo "clean error_log file..."
git clean -df error_log

STAT1=$(git status | grep "nothing to commit, working tree clean")
STATE2="nothing to commit, working tree clean"

if [[ $STAT1 != $STATE2 ]]; then

        echo "there is change need to be staged for commit"  && exit 1
 else
        echo "nothing to commit, working tree clean"  && exit 0
fi

if [ $? -eq 0 ]; then
        echo "Done"
        exit 0
else
        echo "FAUILED!!!"
        exit 1
fi


