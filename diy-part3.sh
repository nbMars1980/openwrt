#!/bin/bash
# File name: diy-part3.sh
# Description: Modify Config File,delete docker and use uhttpd

Use_Uhttpd=true
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
sed -i 's/^#\(.*CONFIG_PACKAGE_luci-app-uhttpd is not set\)/CONFIG_PACKAGE_luci-app-uhttpd=y/g' .config

fi

if $remove_Docker ; then
# remove Docker
sed -i "/^CONFIG_PACKAGE_luci-app-dockerman=y/ s/^/# /g" .config
sed -i "/^CONFIG_PACKAGE_luci-i18n-dockerman-zh-cn=y/ s/^/# /g" .config

sed -i "/^CONFIG_PACKAGE_luci-lib-docker=y/ s/^/# /g" .config

sed -i "/^CONFIG_PACKAGE_docker-ce=y/ s/^/# /g" .config

sed -i "/^CONFIG_DOCKER_\(.*=y\)/ s/^/# /g" .config

fi
