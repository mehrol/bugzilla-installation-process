#!/bin/bash

if [ "$EUID" -eq 0 ]; then
      echo -e "\033[0;32m Congratulations Current User is ROOT User to processing this Process "
    else
      echo "Please first loged  with root user"
fi
echo ""
echo -e "--------------------------------------------------------------------------------\n"
  read -p "Do you want to update and upgrade your system, Press:- Yes or No: "  upgrade
case ${upgrade,,} in
        [yY] | [yY][eE][sS])
        apt update -y && sudo apt upgrade -y
        ;;
        [nN] | [nN][oO])  
        echo -e "\033[0;33m--------> Exiting From Only This Process 😕 <--------" 
        sleep 1s
        break 
        ;;
        *)
        echo -e "\033[0;31m You Have Entered Invalid Key 😕, Press: Yes or No"
        echo -e "\033[0;37m"        
        ;;
esac
echo ""
echo -e "--------------------------------------------------------------------------------\n"
    read -p "Do You Want to Install Dependencies for Bugzilla Then Select:- Yes or No: "  answer
case ${answer,,} in
       [yY] | [yY][eE][sS])
       apt install -y apache2 mariadb-server build-essential libappconfig-perl libdate-calc-perl libtemplate-perl libmime-tools-perl build-essential libdatetime-timezone-perl libdatetime-perl libemail-sender-perl libemail-mime-perl libemail-mime-perl libdbi-perl libdbd-mysql-perl libcgi-pm-perl libmath-random-isaac-perl libmath-random-isaac-xs-perl libapache2-mod-perl2 libapache2-mod-perl2-dev libchart-perl libxml-perl libxml-twig-perl perlmagick libgd-graph-perl libtemplate-plugin-gd-perl libsoap-lite-perl libhtml-scrubber-perl libjson-rpc-perl libdaemon-generic-perl libtheschwartz-perl libtest-taint-perl libauthen-radius-perl libfile-slurp-perl libencode-detect-perl libmodule-build-perl libnet-ldap-perl libfile-which-perl libauthen-sasl-perl libfile-mimeinfo-perl libhtml-formattext-withlinks-perl libgd-dev libmysqlclient-dev graphviz sphinx-common rst2pdf libemail-address-perl libemail-reply-perl
   if [ $? == 0 ]; then
       systemctl start mariadb && systemctl enable mariadb
       systemctl start apache2 && systemctl enable apache2
     else
       sleep 2s
       echo -e "\033[0;31m >>>> Running Installation Has Failed 😕😕 <<<< "
       echo -e "\033[0;37m"
   fi        
       ;;
       [nN] | [nN][oO])
        echo -e "\033[0;33m--------> Exiting From Only This Process 😕 <--------"
        sleep 1s
        break 
        ;;
        *)
        echo -e "\033[0;31m You Have Entered Invalid Key 😕, Press: Yes or No"
        echo -e "\033[0;37m"
        ;;
esac
echo ""
echo -e "--------------------------------------------------------------------------------\n"
if [ $? == 0 ]; then
        read -p "Do you already have DB yes or no : " DB
        if [ "$DB" == "no" ]; then
        read -p "Enter the Database username \n" dbusername
        read -p "Enter the Database password \n" dbpassword
        read -p "Enter the Database name \n " dbname
        mysql -uroot -proot <<EOF
        CREATE USER '$dbusername'@'%' IDENTIFIED BY '$dbpassword';
        CREATE DATABASE $dbname;
        GRANT ALL PRIVILEGES ON $dbname.* TO '$dbusername'@'%';
        FLUSH PRIVILEGES;
EOF
    else
       apt install git -y
       cd /var/www/html
       git clone https://github.com/bugzilla/bugzilla
       cd /var/www/html/bugzilla/
       ./checksetup.pl
       /usr/bin/perl install-module.pl --all
       /usr/bin/perl install-module.pl DateTime
       /usr/bin/perl install-module.pl DateTime::TimeZone
       /usr/bin/perl install-module.pl Template
       /usr/bin/perl install-module.pl Email::Sender
       /usr/bin/perl install-module.pl Email::MIME                                        
       /usr/bin/perl install-module.pl List::MoreUtils                                              
       /usr/bin/perl install-module.pl Math::Random::ISAAC                                              
       /usr/bin/perl install-module.pl JSON::XS                                            
       /usr/bin/perl install-module.pl ExtUtils::PkgConfig module                                           
       /usr/bin/perl install-module.pl PatchReader                                           
    fi
 echo -e "\033[0;35m"  
  if [ $? == 0 ]; then
        rm -rf /var/www/html/bugzilla/localconfig
        echo '$webservergroup = 'www-data';                                             
              $db_driver = 'mysql';
              $db_host = 'localhost';
              $db_name = 'bugzilladb';
              $db_user = 'bugzilla';
              $db_pass = 'bugzilla@321';
              $db_port = 0;' >> /var/www/html/bugzilla/localconfig
              chmod +x /var/www/html/bugzilla/localconfig
              ./checksetup.pl
              rm -rf /etc/apache2/sites-available/bugzilla.conf
              echo '<VirtualHost *:80>
              ServerName 192.168.1.16
              DocumentRoot /var/www/html/bugzilla/
              <Directory /var/www/html/bugzilla/>
              AddHandler cgi-script .cgi
              Options +Indexes +ExecCGI
              DirectoryIndex index.cgi
              AllowOverride Limit FileInfo Indexes Options AuthConfig
              </Directory>
              ErrorLog /var/log/apache2/yourdomain.com.error_log
              CustomLog /var/log/apache2/yourdomain.com.access_log common
              </VirtualHost>' >> /etc/apache2/sites-available/bugzilla.conf
              sudo a2ensite bugzilla.conf
              sudo a2enmod headers env rewrite expires cgi
              apachectl -t
              sudo systemctl restart apache2
              ./checksetup.pl
        else
            echo -e " \033[0;31m !!! mismatch !!! "
            echo -e "\033[0;33m ----------------------------------------------------------------------- "
  fi
fi