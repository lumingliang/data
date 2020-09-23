中标麒麟
IbcFpeEncrypt(
GMSM3(
陕西信息中心
远程接入IP：61.185.238.225.  TCP 25718端口
ntls账号 13141092129    密码gw1admin
 
SSH访问： 172.18.108.27
账号：root
密码：m8#xCGRx1k
m8#xCGRx1k

银河麒麟

远程接入IP：113.194.84.197 TCP   3000端口
密九云账号：  hudl@myibc.net   gw1admin

硬件服务器：
IP：
192.168.1.109
 
SSH访问：
账号：kylin
密码：123123
账号：root
密码：123123

统一平台登录密码
https://192.168.1.107:8443/business_application
superadmin olym_2019

/opt/lnmp/php/bin/php /opt/lnmp/htdocs/app_release_admin/artisan config:cache
/opt/lnmp/php/bin/php /opt/lnmp/htdocs/admin/artisan config:cache

标识管理平台
admin/admin 
https://192.168.36.56:8443/admin/frame_admin.jsp

安装包上传路径
中标麒麟
*public*/产品提交测试目录/密九通/voip华为服务器安装包/voip安装包/


*public*/产品提交测试目录/密九通/voip华为服务器安装包/voip安装包/2020-01-07/

银河麒麟（国产服务器）
*public*/产品提交测试目录/密九通/银河麒麟kylin/服务器安装包/2020-06-28/

*public*/产品提交测试目录/应用发布系统/
中标麒麟
*public*/产品提交测试目录/应用发布系统/陕西微政务ARM/

cat /proc/version
 cat /etc/issue
 uname -a



服务端开发环境
海思+统信UOS
172.18.108.8
用户名：xxzx
密码：Huawei12#$
root密码：Huawei12#$


composer config -g repo.packagist composer https://packagist.phpcomposer.com

在此环境上编译一下mysql5.6.48

cmake -DCMAKE_INSTALL_PREFIX=/opt/lnmpp/mysql -DMYSQL_DATADIR=/opt/lnmpp/mysql/data -DSYSCONFDIR=/opt/lnmpp/mysql/etc -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DMYSQL_UNIX_ADDR=/tmp/mysqld.sock -DMYSQL_TCP_PORT=3306 -DENABLED_LOCAL_INFILE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci


openssl-1.1.0j.tar.gz下载地址
后来参考这篇文章
1../config shared zlib
2.提醒需要在build之前做make depend
make depend
3.make && make install
4.keepalived可以正常安装
注意：通过这种安装方式，openssl和openssl-devel都将会被安装
 ssh-keygen -o


1、dpkg -i <package.deb>
安装一个 Debian 软件包，如你手动下载的文件。
2、dpkg -c <package.deb>
列出 <package.deb> 的内容。
3、dpkg -I <package.deb>
从 <package.deb> 中提取包裹信息。
4、dpkg -r <package>
移除一个已安装的包裹。
5、dpkg -P <package>
完全清除一个已安装的包裹。和 remove 不同的是，remove 只是删掉数据和可执行文件，purge 另外还删除所有的配制文件。
6、dpkg -L <package>
列出 <package> 安装的所有文件清单。同时请看 dpkg -c 来检查一个 .deb 文件的内容。
7、dpkg -s <package>
显示已安装包裹的信息。同时请看 apt-cache 显示 Debian 存档中的包裹信息，以及 dpkg -I 来显示从一个 .deb 文件中提取的包裹信息。
8、dpkg-reconfigure <package>
重新配制一个已经安装的包裹，如果它使用的是 debconf (debconf 为包裹安装提供了一个统一的配制界面)。

         response.setCharacterEncoding("UTF-8");
            response.setContentType("application/json; charset=utf-8");
            PrintWriter out = null ;
            JSONObject res = new JSONObject ();
            res.put("resultCode",302);
            res.put("message","sessionId 已失效");
            out = response.getWriter();
            out.append(res.toString());
————————————————
版权声明：本文为CSDN博主「hp15」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/haponchang/java/article/details/105203299


sandbox_white_list


