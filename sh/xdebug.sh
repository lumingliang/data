#!/bin/bash

echo 'zend_extension=/xdebug.so
xdebug.remote_enable=1
xdebug.remote_handler=dbgp
xdebug.remote_mode=req
xdebug.remote_host=localhost
xdebug.remote_port=9001
xdebug.idekey="PHPSTORM"
xdebug.remote_autostart = On' >> /opt/lnmp/php/etc/php.ini

