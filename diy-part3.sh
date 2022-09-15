#!/bin/bash
# File name: diy-part3.sh
# Description: Modify Config File,delete docker and use uhttpd

Use_Uhttpd=false
remove_Docker=true

if $Use_Uhttpd ; then
# remove nginx and use uhttpd
sed -i "/^CONFIG_PACKAGE_nginx=y/ s/^/# /g" .config
sed -i "/^CONFIG_PACKAGE_nginx-mod-luci-ssl=y/ s/^/# /g" .config
sed -i "/^CONFIG_PACKAGE_nginx-util=y/ s/^/# /g" .config

sed -i "/^CONFIG_PACKAGE_luci-nginx=y/ s/^/# /g" .config
sed -i "/^CONFIG_PACKAGE_luci-ssl-nginx=y/ s/^/# /g" .config
sed -i "/^CONFIG_PACKAGE_luci-ssl-openssl=y/ s/^/# /g" .config

sed -i "/^CONFIG_PACKAGE_nginx-mod-luci=y/ s/^/# /g" .config
sed -i "/^CONFIG_PACKAGE_nginx-ssl=y/ s/^/# /g" .config
sed -i "/^CONFIG_PACKAGE_nginx-ssl-util=y/ s/^/# /g" .config

sed -i "/^CONFIG_NGINX_\(.*=y\)/ s/^/# /g" .config

# Use uhttpd
if [ ! -z `sed -n '/^#\(.*CONFIG_PACKAGE_luci-app-uhttpd is not set\)/=' .config` ];then
    sed -i 's/^#\(.*CONFIG_PACKAGE_luci-app-uhttpd is not set\)/CONFIG_PACKAGE_luci-app-uhttpd=y/g' .config
else
    sed -i '$a CONFIG_PACKAGE_luci-app-uhttpd=y' .config
fi
sed -i "s/\(listen_http.*\):82/\1:80/g" package/network/services/uhttpd/files/uhttpd.config
sed -i "s/^#\(.*list listen_https\)/\1/" package/network/services/uhttpd/files/uhttpd.config

fi

if $remove_Docker ; then
# remove Docker
sed -i "/^CONFIG_PACKAGE_luci-app-dockerman=y/ s/^/# /g" .config
sed -i "/^CONFIG_PACKAGE_luci-i18n-dockerman-zh-cn=y/ s/^/# /g" .config

sed -i "/^CONFIG_PACKAGE_luci-lib-docker=y/ s/^/# /g" .config

sed -i "/^CONFIG_PACKAGE_docker-ce=y/ s/^/# /g" .config

sed -i "/^CONFIG_DOCKER_\(.*=y\)/ s/^/# /g" .config

fi
