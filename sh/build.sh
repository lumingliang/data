#!/bin/bash 

work_dir=`pwd`
curren_object=`basename $work_dir|sed "s/_ramdisk//g"`
curren_user=$curren_object
curren_version=""
#chroot rootfs
#cd /opt/lnmp/htdoc/admin

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

#echo "removing tmp file"
#. ./clear_file.sh

echo "removing old image"
rm -f $img'.gz'
echo "buiding new image"
make48 $img

if [ ! -d "./boot" ]; then
	echo -n "md5sum: "
	md5sum "$img".gz
    mv "$img".gz ramdisk_`date "+%Y%m%d%H%M"`.img.gz
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

