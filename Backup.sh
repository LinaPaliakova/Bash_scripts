#!/bin/bash

#This script is aimed to create a backup of folder. All actions performed by script are logged into backup_logs

echo " Starting a script "  >> /home/cloud_user/backup_logs
echo " Creating directory "  >> /home/cloud_user/backup_logs
mkdir /home/cloud_user/work_backup >> /home/cloud_user/backup_logs
echo " Creating a backup " >> /home/cloud_user/backup_logs
cp -v /home/cloud_user/work/*  /home/cloud_user/work_backup >> /home/cloud_user/backup_logs
echo " The script finished " >> /home/cloud_user/backup_logs
