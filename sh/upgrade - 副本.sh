#!/bin/bash 
work_dir=`pwd`"/data/"

install_script_sql_name="update20200312.sql"
install_script_tar="admin20200312.tar.gz"
sql_password="rBoLKPkoUIX6BQPU"


tar czf /opt/lnmp/htdocs/blog/admin_`date "+%Y%m%d%H%M"`.tar.gz /opt/lnmp/htdocs/blog/admin

tar -xzf $work_dir$install_script_tar -C /opt/lnmp/htdocs/blog/


p="/tmp" #目录下全是sql文件
dbUser='root'
dbPassword='rBoLKPkoUIX6BQPU'
dbName='thinkcmf5'
f=$work_dir$install_script_sql_name
/opt/lnmp/mysql/bin/mysql -u $dbUser -p$dbPassword $dbName -e "source $f";


/opt/lnmp/lnmp stopphp
/opt/lnmp/lnmp startphp
/opt/lnmp/lnmp stopmysql
/opt/lnmp/lnmp startmysql

echo 'finished!'