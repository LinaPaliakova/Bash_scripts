#Script to install automatically zabbix server

#!/bin/bash

#Making sure that users will see notitifcation if they will try to run a script not as root user

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


#Changing Selinux mode

setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config

#Installing httpd
echo "Installing httpd"
yum -y install httpd
systemctl start httpd
systemctl enable httpd
echo " Httpd is enabled"

# Making changes to firewall rules
echo "Enabling firewall rules for http and https"
firewall-cmd --add-service={http,https} --permanent
firewall-cmd --reload

#installing mariadb
echo "Starting mariadb installation"

yum -y install mariadb-server
systemctl start mariadb.service
systemctl enable mariadb
echo "mariadb is enabled"

#chanding initial password of database
mysql_secure_installation <<EOF

y
secret
secret
y
y
y
y
EOF
#Creating database and user
export zabbix_db_pass="StrongPassword"
mysql -uroot -psecret <<EOF
    create database zabbix character set utf8 collate utf8_bin;
    CREATE USER 'zabbix'@localhost IDENTIFIED BY '${zabbix_db_pass}';
    grant all privileges on zabbix.* to zabbix@'localhost' identified by '${zabbix_db_pass}';
    FLUSH PRIVILEGES;
EOF

#Installing Zabbix
yum -y install https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
yum -y install zabbix-server-mysql  
yum-config-manager --enable zabbix-frontend
yum -y install centos-release-scl
yum -y install zabbix-web-mysql-scl zabbix-apache-conf-scl

#Installing Zabbix server Database schema

zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -pgPassword zabbix

#Editing Zabbix conf file
sed -i "s/# DBHost=localhost/DBHost=localhost/" /etc/zabbix/zabbix_server.conf
sed -i "s/DBName=zabbix/DBName=zabbix/g" /etc/zabbix/zabbix_server.conf
sed -i "s/DBUser=zabbix/DBUser=zabbix/g" /etc/zabbix/zabbix_server.conf
sed -i "s/# DBPassword=/DBPassword=StrongPassword/g" /etc/zabbix/zabbix_server.conf

#Editing PHP timezone
sed -i 's/; php_value\[date\.timezone\] = Europe\/Riga/php_value\[date\.timezone\] = America\/Atikokan/g' /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf

systemctl restart zabbix-server  httpd rh-php72-php-fpm
systemctl enable zabbix-server  httpd rh-php72-php-fpm

#Configuring firewall
firewall-cmd --add-port={10051/tcp,10050/tcp} --permanent
firewall-cmd --reload
systemctl restart httpd

#Configuring php for zabbix server

sed -i "s/max_execution_time = 30/max_execution_time = 300/g" /etc/php.ini.rpmsave
sed -i "s/max_input_time = 60/max_input_time = 300/g" /etc/php.ini.rpmsave
sed -i "s/; max_input_vars = 1000/max_input_vars = 10000/g" /etc/php.ini.rpmsave
sed -i "s/post_max_size = 8M/post_max_size = 16M/g" /etc/php.ini.rpmsave
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 8M/g" /etc/php.ini.rpmsave


#Restarting of all services
systemctl restart httpd
systemctl restart mariadb
systemctl restart rh-php72-php-fpm
systemctl restart zabbix-server



