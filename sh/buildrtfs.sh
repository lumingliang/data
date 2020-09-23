#!/bin/bash 

work_dir=`pwd`
curren_object=`basename $work_dir|sed "s/_ramdisk//g"`
curren_user=$curren_object
curren_version=""


if [ "$curren_object" == "ntls_comm" -o "$curren_object" == "binder" -o "$curren_object" == "ntls_zjdx" ]; then
	curren_user="public"	
elif [ "$curren_object" == "zdm_smtp" ]; then
	sed -i 's/^CUR_PROJECT=.*\#/CUR_PROJECT="all" #/g' rootfs/config_def/etc/init.d/rc.local		
fi

if [ -f "../ramdisk_script/upgrade" ]; then
	install_script_name=$curren_object"_ramdisk_install"
	install_script=$install_script_name".sh"
	install_script_tar=$install_script_name".tar.gz"
	
	chmod 555 ../ramdisk_script/*.sh
	if [ -L "ramdisk_install.sh" ]; then
		/bin/cp ramdisk_install.sh  $install_script
		sed -i "s/ramdisk_install/${curren_object}_ramdisk/g" $install_script	
	elif [ -e "../ramdisk_script/$install_script" ]; then
		if [ -d "$install_script_name" ]; then
			/bin/cp ../ramdisk_script/$install_script  $install_script_name
			install_script=$install_script_name/$install_script
		else
			/bin/cp ../ramdisk_script/$install_script  $install_script
		fi
		sed -i "s/ramdisk_install/${curren_object}_ramdisk/g" $install_script	
	fi	
	echo "upgrade chroot install script: $install_script"
	
	rm -rf $install_script_tar
	tar zcf $install_script_tar ${install_script_name}*
fi


version_file="rootfs/config_def/www/conf/myconfig.php"
if [ -f "$version_file" ]; then
        version_file_2="rootfs/config_def/www/conf/myconfig_smtp.php"
        if [ -f "$version_file_2" ]; then
                version_file=$version_file_2
        fi
        curren_version=`grep "soft_version" $version_file |sed "s/ //g" |cut -d "="  -f 2 | cut -d "(" -f 1 |sed "s/[\"']//g"`
        sed -i 's/\$config\["cur_user"\]=".*";/\$config\["cur_user"\]="'$curren_user'";/' $version_file
fi

if [ -f "rootfs/config_def/etc/versions/version.info" ]; then
	#update system-rootfs version
	curren_version=`grep "Version" rootfs/config_def/etc/versions/version.info |cut -d ":" -f 2| sed "s/\[\|\]//g"`
	if [ -z "`echo $curren_version |cut -d '.' -f 4`" ]; then
		curren_version=${curren_version}.1
	else
		rev_version=`echo $curren_version | rev`
		old_smail_ver=`echo $rev_version | cut -d '.' -f 1`
		tmpval=`echo $old_smail_ver |rev`
		new_smail_ver=`expr $tmpval  + 1 |rev`
		curren_version=`echo $rev_version | sed "s/^${old_smail_ver}./${new_smail_ver}./g" |rev`
	fi
	sed -i "s/Version:.*/Version:[$curren_version]/" rootfs/config_def/etc/versions/version.info
fi

img=ramdisk.img
make48() {
   echo "Direct usr /rootfs process it now............."

   cd rootfs
  find . | cpio -o -H newc > ../$1
 # find . | cpio -o -c > ../$1
   cd ..
   gzip -v9 $1

   echo "Finished..."
   echo " IMAGEE FILE    : $1"
   echo -e "\a"
}

if [ $# -lt 0 ] ; then
   echo "Format: "
   echo "use ./release file.img"
   echo ""
   exit 1
fi

echo "removing tmp file"
. ./clear_file.sh

echo "removing old image"
rm -f $img'.gz'
echo "buiding new image"
make48 $img

if [ ! -d "./boot" ]; then
	exit 
fi

echo "copy image to boot"
cp -f $img'.gz' ./boot
rm -f boot.tar.gz
boot_file_name=boot_${curren_object}_`date "+%Y%m%d%H%M"`_v${curren_version}.tar.gz
tar czf $boot_file_name ./boot
rm -rf boot.tar.gz 
ln -s $boot_file_name boot.tar.gz
echo -n "md5sum: "
md5sum $boot_file_name

