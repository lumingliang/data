#!/bin/bash

#disDir=/opt/lnmp/voip_ramdisk/rootfs/opt/lnmp/htdocs/admin/
disDir=/lml/test
mkdir -p $disDir

function listDir() {
    for file in `ls -a $1`
    do
        if [[ ! -h "$1/$file" ]]
        then
            echo "$1/$file"
            cp -ra "$1/$file" $disDir
#            continue
        fi
    done
}

case $1 in
    test)
        listDir $2 ;;
esac

