#!/bin/bash

#This script is aimed to create a backup of folder. All actions performed by script are logged into backup_logs
if [ -z "$1" ]; then
                echo "You have failed to pass a parameter. Please try again."
                        exit 255;
                fi
mylog=$1
date=`date`
function MyExit {
rm -rf /home/$USER/work_backup
rm -f /home/$USER/$mylog
echo "Received Ctrl+C"
 exit 255
 }

trap MyExit SIGINT
echo "Timestamp before work is done $date" >> /home/$USER/$mylog
echo "Creating backup directory" >> /home/$USER/$mylog
mkdir /home/$USER/work_backup

echo "Copying Files" >> /home/$USER/$mylog
cp -v /home/$USER/work/* /home/$USER/work_backup/ >> /home/$USER/$mylog
echo "Finished Copying Files" >> /home/$USER/$mylog
echo "Timestamp after work is done $date" >> /home/$USER/$MYLOG

sleep 15
