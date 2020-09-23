#!/bin/sh

ramdisk_src="/ntls_sslvpn_check_ramdisk/rootfs"
ramdisk_file="ramdisk.img.gz"
start_nat=0

echo -e "\n根目录空间大小检测..."
sleep 1
# grep -E == egrep 过滤
#匹配根挂载点 '/ '
disk_size=`df -HP | awk '{print $6,$m}' | grep -E "^/ "`
# 输出根挂载点的容量
echo -n "硬盘大小：" && echo "$disk_size" | awk '{print $3}'
# hP 比 HP显示更精确的大小
surplus_size=`df -hP | awk '{print $6,$4}' | grep -E "^/ " |awk '{print $2}'`
echo "可用大小：$surplus_size" 

# k 来表示
surplus_size_format=`df -kP | awk '{print $6,$4}' | grep -E "^/ " |awk '{print $2}'`
gb_num=`expr $surplus_size_format / 1000 / 1000`

custom_num=3
if [ $gb_num -lt $custom_num ]; then
	echo "ERROR: 可用空间不足,不能小于${custom_num}G" 
	exit 1
fi

read -p "即将安装RAMDISK到$ramdisk_src，输入y确认安装！" answer
if [ "$answer" ==  "y" -o "$answer" == "Y"  -o "$answer" == "YES"  -o "$answer" == "yes"  ]; then
	echo ' ' >/dev/null
else
	echo '退出安装'
	exit 1
fi

if [ -e $ramdisk_src ];then
	MOUNT_WARNING_MSG=""
	tmpval=`mount | grep "$ramdisk_src"  |awk '{print $3}'`
	if [ -n "$tmpval" ]; then
		echo "挂载中的目录：$tmpval"
		MOUNT_WARNING_MSG="(请不要执行删除$ramdisk_src 目录的操作!!!)"
	fi
	echo -e "ERROR: $ramdisk_src 目录已存在，请卸载ramdisk后再次安装!$MOUNT_WARNING_MSG\n"
	exit 1
fi

tmpval=`grep "$ramdisk_src" /etc/rc.local`
if [ -n "$tmpval" ]; then
	echo "ERROR: 请清空 /etc/rc.local 中的$tmpval 后重新安装!"
	exit 1
fi

if [ ! -f $ramdisk_file ]; then
	echo "ERROR: $ramdisk_file 文件不存在!"
	exit 1			
fi

tmpval=`grep "/ext/my_rc.local" /etc/rc.local`
if [ -n "$tmpval" ]; then
	echo "NOTICE: /etc/rc.local 中发现多个chroot环境!"
fi
#检测操作系统版本
if [ -f "/etc/redhat-release" -o  -n "`grep 'CentOS' /etc/issue`" ]; then
        [ -n "`grep  ' 7\.' /etc/redhat-release`" ] &&  os_version=7
        [ -n "`grep  ' 6\.' /etc/redhat-release`" ] &&  os_version=6
fi

echo -e "\n创建目录$ramdisk_src"
mkdir  $ramdisk_src -p

echo "禁用SELINUX设置"
/bin/sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config

echo -e "\n设置/etc/sysctl.conf"
sed -i "/^net.ipv4.ip_forward/d" /etc/sysctl.conf
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p 2>&1 >/dev/null

#postfix 占用25端口
rpm --nodeps -e postfix 2>/dev/null

#load module
iptables -L 2>&1 >/dev/null && iptables -F 2>&1 >/dev/null && ebtables -L 2>&1 >/dev/null  && modprobe af_key 2>/dev/null

echo ""
echo "部署ramdisk环境"
/bin/cp $ramdisk_file  $ramdisk_src
cd $ramdisk_src 
gunzip  $ramdisk_file
cpio -imd <  ramdisk.img
rm -rf ramdisk.img
sed -i "s/hostname.*/#hostname/g"  config_def/etc/init.d/rc.local 
sed -i "s@/sbin/hwclock.*@#/sbin/hwclock --hctosys@g"  config_def/etc/init.d/rc.local 


if [ "$start_nat" == "1"  ]; then
	if [ -f "config_def/ntls_v2/config/ntls_server.xml" -a -f "config_def/ntls_v2/script/start_nat.sh.bak" ]; then
		echo -e "\n开启虚拟子网地址转换"
		sed -i "s/<nat>0<\/nat>/<nat>1<\/nat>/g" config_def/ntls_v2/config/ntls_server.xml
		sed -i "s/<nat>0<\/nat>/<nat>1<\/nat>/g" config_def/ntls_v2/config/ntls_server_file.xml
		sed -i "s/<nat>0<\/nat>/<nat>1<\/nat>/g" config_def/ntls_v2/config/ntls_server_dev.xml
		mv config_def/ntls_v2/script/start_nat.sh.bak  config_def/ntls_v2/script/start_nat.sh 
	fi
fi

#centos 7  support
export PATH=$PATH:/bin:/sbin
tmpval=`grep "/bin:/sbin"  ~/.bashrc`
if [ -z "$tmpval" ]; then
	echo "export PATH=\$PATH:/bin:/sbin"  >>  ~/.bashrc
fi

tmpval=`echo "$ramdisk_src" | grep ibc_`
ibc_flag=0
if [ "$os_version" == "6" -a -n "$tmpval" ]; then
	ibc_flag=1
	mount --bind /dev/.udev/ $ramdisk_src/mnt/log/.udev
	#ramdisk 7.x 部署到centos 6.x时
fi

MYSQL_SERVER_CHECK=`netstat -an | grep ":3306 .*LISTEN"`
WEB_SERVER_CHECK=`netstat -an | grep ":8443 .*LISTEN"`
PHP_SERVER_CHECK=`netstat -an | grep ":9000 .*LISTEN"`
if [ -n "$MYSQL_SERVER_CHECK" -o  -n "$WEB_SERVER_CHECK" ]; then
	echo -e "\n安装已成功，但以下端口被占用，重启机器后可以修复此问题。"
	echo $MYSQL_SERVER_CHECK|sed "s/ /\t/g"
	echo $WEB_SERVER_CHECK |sed "s/ /\t/g"
	echo $PHP_SERVER_CHECK |sed "s/ /\t/g"
	sed -i "/rc.local/d"  ext/init_sys.sh 
fi

# 运行子进程
chroot $ramdisk_src /bin/bash -c "/bin/sh /ext/init_sys.sh"

echo -e "\n退出chroot,修改rc.local启动脚本"
sed -i "/reboot=/d" /etc/profile
sed -i "/poweroff=/d" /etc/profile
echo "alias reboot='reboot -f'" >> /etc/profile
echo "alias poweroff='poweroff -f'" >> /etc/profile
alias reboot='reboot -f' >/dev/null
alias poweroff='poweroff -f' >/dev/null
if [ ! -d "/etc/sysconfig/network-scripts.bak" ]; then
	/bin/cp -a /etc/sysconfig/network-scripts /etc/sysconfig/network-scripts.bak
fi
mount --bind /etc/sysconfig/network-scripts/  $ramdisk_src/config_def/etc/sysconfig/network-scripts/

if [ ! -d $ramdisk_src/lib/modules/`uname -r` ]; then
	/bin/cp $ramdisk_src/dev/rtc0 $ramdisk_src/dev/rtc0.def -a
	/bin/cp /dev/rtc0 $ramdisk_src/dev -a
fi

cat > /etc/rc.local <<EOF
#!/bin/bash
# THIS FILE IS ADDED FOR COMPATIBILITY PURPOSES
#
# It is highly advisable to create own systemd services or udev rules
# to run scripts during boot instead of using this file.
#
# In contrast to previous versions due to parallel execution during boot
# this script will NOT be run after all other services.
#
# Please note that you must run 'chmod +x /etc/rc.d/rc.local' to ensure
# that this script will be executed during boot.

touch /var/lock/subsys/local

iptables -L 2>&1 >/dev/null && iptables -F 2>&1 >/dev/null && ebtables -L 2>&1 >/dev/null && modprobe af_key 2>/dev/null
mount --bind /etc/sysconfig/network-scripts/  $ramdisk_src/config_def/etc/sysconfig/network-scripts/
EOF

if [ "$ibc_flag" == "1" ]; then
	echo "mount --bind /dev/.udev/ $ramdisk_src/mnt/log/.udev" >> /etc/rc.local
fi
echo "chroot $ramdisk_src /bin/bash -c '/bin/sh /ext/my_rc.local' && /sbin/hwclock --hctosys" >> /etc/rc.local

chmod a+x /etc/rc.local
echo "安装完成，请重启机器."
