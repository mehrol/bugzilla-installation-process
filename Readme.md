***Bugzilla-installation and basic understanding given below.

Run bash script of "bugzilla-installation.sh" for installing bugzilla server.
In this script you have asked first to update or upgrade system that was optional if you are recently update your system, then we have installed some bugzilla dependencies where we use mariadb as database and apache server for service bugzilla web interface.
We have then create option if you want to create db or you can exit if you have already created db.
then we have pull bugzilla tar file in /var/www/html from git hub, which was publicaly accissible and untar that file there and give ownership to bugzilla direcroty as "www-data" for smooth executions of all bugzilla files.
When you creating DB username,password and database name then give it according to you, i just mantioned * at that place, which you can replace according to your sytem requirment.
now you can run your bugzilla server with your localhost and private IP.


***Bugzilla-Backup and sechduling,mounting windows direcotory 

In our case we have windows server for backup and we create a network directory and share this with particular username and password of my windows machine.
then we have to create directory in linux machine like /home/test
Now we have to run below command to mount your windows network drive in linux mahcine with /home/test directory.
     apt install cifs-utils -y
     sudo mount.cifs //remote-machine-ip/network-dir-name /home/test -o username=abc,password=abc@123,uid=$(id -u),gid=$(id -g)
if successfully mounted then run command given below to check that mounted correctly. 
      df -h
Create a directory for local path also, in local path first data backup in local path then copy in /home/test which was mounted with our windows machine, after this process local path files remove after successfully copied.
When you have created mount point successfully then run script "backup-DB.sh" to take your db backup, but you have to enter db username and db password and db name which was you created at the time of bugzilla installation.
