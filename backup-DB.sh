#!/bin/bash
echo -e "\nCheck Multiple DB Options for Backup\n"
PS3="Choose Number for DB Backup : "


#select work in mysql_db_backup Postgres
#do
#case ${work} in
#mysql_db_backup)


#read -p "Enter DataBase User Name : " username
#read -p "Please Ener DB password : " -s dbpasswd
#mysql -u $username -p"$dbpasswd" -e "SHOW DATABASES;"
#read -p "Enter DataBase Name for Backup : " dbname
dbname="bugzilladb"
Date=`date "+%F %H:%M:%S"`
#remote_IP="test@192.168.1.203"
local_path="/home/bugzilla/backup/"
mount_path="/home/bugzilla/bugzilla-windows-backup/"
mysqldump -ubugzilla -pbugzilla@321 bugzilladb > $local_path"$dbname"-"$Date".sql
#scp "$local_path"*.sql "$remote_IP":"$remote_path"
cp -r /home/bugzilla/backup/* /home/bugzilla/bugzilla-windows-backup/
if [ $? == 0 ]
        then
        {

        rm -rf "$local_path"*.sql
        find $mount_path -type f -mtime +10 -exec rm {} \;
        exit 1
         }
else
        {
         echo -e "\n Backup Failure\n"
        }
fi