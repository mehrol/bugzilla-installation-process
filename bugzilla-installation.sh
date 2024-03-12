#!/bin/bash

if [ "$EUID" -eq 0 ]
        then
                echo "congratulations you are root user to use this installation process"
        else
                echo "Please first loged in with root user"
fi

read -p "Do you want to update and upgrade your system yes or no\n"  upgrade
if [ "$upgrade" == "yes" ]
        then
                apt update -y && sudo apt upgrade -y
        else
                if [ "$upgrade" == "no" ]
                        then
                                exit1
                fi
fi


read -p "Do you want to install dependencies for bugzilla yes or no\n"  dependencies
if [ "$dependencies" ==  "yes" ]
        then
                apt install -y apache2 mariadb-server build-essential libappconfig-perl libdate-calc-perl libtemplate-perl libmime-tools-perl build-essential libdatetime-timezone-perl libdatetime-perl libemail-sender-perl libemail-mime-perl libemail-mime-perl libdbi-perl libdbd-mysql-perl libcgi-pm-perl libmath-random-isaac-perl libmath-random-isaac-xs-perl libapache2-mod-perl2 libapache2-mod-perl2-dev libchart-perl libxml-perl libxml-twig-perl perlmagick libgd-graph-perl libtemplate-plugin-gd-perl libsoap-lite-perl libhtml-scrubber-perl libjson-rpc-perl libdaemon-generic-perl libtheschwartz-perl libtest-taint-perl libauthen-radius-perl libfile-slurp-perl libencode-detect-perl libmodule-build-perl libnet-ldap-perl libfile-which-perl libauthen-sasl-perl libfile-mimeinfo-perl libhtml-formattext-withlinks-perl libgd-dev libmysqlclient-dev graphviz sphinx-common rst2pdf libemail-address-perl libemail-reply-perl
                if [ $? == 0 ]
                        then
                                systemctl start mariadb && systemctl enable mariadb
                                systemctl start apache2 && systemctl enable apache2
                        else
                                echo "Unsuccessfull installation"
                fi
        else
                if [ "$dependencies" == "no" ]
                        then
                                exit 1
                fi
fi
                                if [ $? == 0 ]
                                then
                                        read -p "Do you already have DB yes or no : " DB
                                        if [ "$DB" == "no" ]
                                        then
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
                                                if [ $? == 0 ]
                                                then
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
                                                        echo "mismatch"
                                        fi
                                fi
