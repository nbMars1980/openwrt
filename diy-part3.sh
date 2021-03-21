#!/bin/bash
# File name: diy-part3.sh
# Description: Modify Config File,delete docker and use uhttpd
#
# remove nginx 
sed -i "/CONFIG_PACKAGE_luci-nginx=y/ s/^/#/g" .config
sed -i "/CONFIG_PACKAGE_luci-ssl-nginx=y/ s/^/#/g" .config
sed -i "/CONFIG_PACKAGE_luci-ssl-openssl=y/ s/^/#/g" .config
