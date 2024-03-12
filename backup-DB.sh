#!/bin/bash
echo -e "\033[0;32m\n >>>>>> Check Multiple DB Options for Backup <<<<<<"
PS3="Choose Number for DB Backup : "
     echo -e "\033[0;33m]"
     dbname="bugzilladb"
     Date=`date "+%F %H:%M:%S"`
     local_path="/home/bugzilla/backup/"
     mount_path="/home/bugzilla/bugzilla-windows-backup/"
     mysqldump -ubugzilla -pbugzilla@321 bugzilladb > $local_path"$dbname"-"$Date".sql
     echo -e "\033[0;34m"  
     cp -r /home/bugzilla/backup/* /home/bugzilla/bugzilla-windows-backup/
if [ $? == 0 ]
    then
     rm -rf "$local_path"*.sql
     find $mount_path -type f -mtime +10 -exec rm {} \;
     exit 1
    else
     echo "----------------------------------------------------"
     echo -e "\033[0;31m \n!!!!! Backup Failure !!!!! "
fi