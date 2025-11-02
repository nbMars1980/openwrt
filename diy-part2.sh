#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

#tomato界面主题中，passwall和passwall2菜单active存在冲突解决
sed -i 's/if (href.indexOf(nodeUrl) != -1)/if (href.substr(href.length-nodeUrl.length,nodeUrl.length) == nodeUrl)/g' feeds/kenzo/luci-theme-tomato/htdocs/luci-static/tomato/js/script.js

# Modify default IP
sed -i 's/192.168.1.1/192.168.0.250/g' package/base-files/files/bin/config_generate
sed -i 's|192.168.$((addr_offset++)).1|192.168.$((addr_offset++)).250|g' package/base-files/files/bin/config_generate
sed -i 's|LEDE|openwrt|g' package/base-files/files/bin/config_generate

# Set Display Version number
displayver=R$(date +'%y.%-m.%-d-%H%M%S')
sed -i "/DISTRIB_REVISION='R/{s|\(.\+\)'\(.\+\)'\(.\+\)|\1'$displayver Compiled by Mars'\3|;;}" package/lean/default-settings/files/zzz-default-settings
displayver=

# remove default root password
sed -i '/root\(.*\)shadow/d' package/lean/default-settings/files/zzz-default-settings

# Modify default close dhcpv6
#sed -i '/dhcp.lan.\(.*$MODE\)/ s/^/# /g' package/network/services/odhcpd/files/odhcpd.defaults

# Change nginx and uhttpd default config
sed -i "s/\(listen_http.*\):80/\1:82/g" package/network/services/uhttpd/files/uhttpd.config
sed -i "/list listen_https/ s/^/# /g" package/network/services/uhttpd/files/uhttpd.config
sed -i "s/128M/512M/g" feeds/packages/net/nginx-util/files/uci.conf.template
cp -f files/nginx.config feeds/packages/net/nginx-util/files/
cp -f files/60_nginx-luci-support feeds/packages/net/nginx/files-luci-support/
cp -f files/luci.locations feeds/packages/net/nginx/files-luci-support/

# Add ext default config
sed -i '/exit\(.*0\)/d' package/lean/default-settings/files/zzz-default-settings
cat files/ext-default-settings >> package/lean/default-settings/files/zzz-default-settings

#  修复 ERROR: package/feeds/packages/uwsgi failed to build.问题
if [ -d "feeds/packages/net/uwsgi" ]; then
  echo "Upgrading uwsgi from 2.0.20 (coolsnowwolf) to 2.0.30 (openwrt/packages)..."
  # Backup original
  mv feeds/packages/net/uwsgi feeds/packages/net/uwsgi.backup
  # Clone official openwrt/packages uwsgi using sparse checkout
  mkdir -p /tmp/openwrt-packages-uwsgi
  cd /tmp/openwrt-packages-uwsgi
  git init
  git remote add origin https://github.com/openwrt/packages.git
  git config core.sparseCheckout true
  echo "net/uwsgi/*" > .git/info/sparse-checkout
  git pull --depth=1 origin master
    # Copy to feeds
  cp -r net/uwsgi "$GITHUB_WORKSPACE/openwrt/feeds/packages/net/"

  # Cleanup
  cd "$GITHUB_WORKSPACE/openwrt"
  rm -rf /tmp/openwrt-packages-uwsgi

  echo "✓ uwsgi upgraded to 2.0.30 (Python 3.11 compatible)"
fi
# 尝试修复代码结束