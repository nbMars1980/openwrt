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

#remove coolsnowwolf smartdns,Use kenzok8 smartdns
#cp .config .config.bak
#./scripts/feeds uninstall smartdns 
./scripts/feeds install -fp kenzo smartdns 
#./scripts/feeds install -fp small trojan simple-obfs dnsproxy
# --下次可能需要恢复-- ./scripts/feeds uninstall luci-app-passwall
# --下次可能需要恢复-- ./scripts/feeds install -afp xiaorouji   
#dns2socks ipt2socks microsocks pdnsd-alt luci-app-passwall
#mv -f .config.bak .config

#tomato界面主题中，passwall和passwall2菜单active存在冲突解决
sed -i 's/if (href.indexOf(nodeUrl) != -1)/if (href.substr(href.length-nodeUrl.length,nodeUrl.length) == nodeUrl)/g' feeds/kenzo/luci-theme-tomato/htdocs/luci-static/tomato/js/script.js

######上游已打补丁，xray相关的可以直接用golang1.21编译了
#xray-core需要golang1.22才能编译
#rm -rf feeds/packages/lang/golang
#git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang
###拉去一个临时补丁
#git remote add sbwml https://github.com/sbwml/openwrt_helloworld.git
#git fetch sbwml go1.21
#git checkout 0389f82 -- xray-plugin/patches/010-go1.21.patch
#mv xray-plugin/patches/010-go1.21.patch feeds/small/xray-plugin/patches/
#rm feeds/small/xray-plugin/patches/0001-fix-go-1.21-build-error.patch
###
#####给v2ray-plugin打补丁，使用go1.21编译
mkdir -p feeds/small/v2ray-plugin/patches && cat > feeds/small/v2ray-plugin/patches/0001-fix-go-1.21.patch <<EOF
--- a/go.mod
+++ b/go.mod
@@ -1,6 +1,6 @@
 module github.com/shadowsocks/v2ray-plugin

-go 1.22
+go 1.21.5

 require (
 	github.com/golang/protobuf v1.5.3
EOF

#解决small/gn编译失败问题
#sudo apt install clang

# curl/8.5.0 - fix passwall `time_pretransfer` check
#rm -rf feeds/packages/net/curl
#git clone https://github.com/sbwml/feeds_packages_net_curl feeds/packages/net/curl

#aliyundrive-webdav 使用kenzo的
cp .config .config.bak
./scripts/feeds uninstall aliyundrive-webdav luci-app-aliyundrive-webdav
./scripts/feeds install -fp kenzo aliyundrive-webdav luci-app-aliyundrive-webdav
mv -f .config.bak .config
#sed -i "s/stripped/release/g" feeds/packages/multimedia/aliyundrive-webdav/Makefile

# Modify default IP
sed -i 's/192.168.1.1/192.168.0.250/g' package/base-files/files/bin/config_generate
# Set Display Version number
displayver=R$(date +'%y.%-m.%-d-%H%M%S')
sed -i "/DISTRIB_REVISION='R/{s|\(.\+\)'\(.\+\)'\(.\+\)|\1'$displayver Compiled by Mars'\3|;;}" package/lean/default-settings/files/zzz-default-settings
displayver=

# remove default root password
sed -i '/root\(.*\)shadow/d' package/lean/default-settings/files/zzz-default-settings

# modify ttnode and jd-dailybonus notify server url
#sed -i "s|https://\(.*\)ftqq.com/|http://192.168.0.3:2443/|g" package/lean/luci-app-ttnode/root/usr/share/ttnode/ttnode.lua
# feeds/kenzo/luci-app-ttnode/root/usr/share/ttnode/ttnode.lua 
#sed -i "s|https://\(.*\)ftqq.com/|http://192.168.0.3:2443/|g" package/lean/luci-app-jd-dailybonus/root/usr/share/jd-dailybonus/newapp.sh
# feeds/kenzo/luci-app-jd-dailybonus/root/usr/share/jd-dailybonus/newapp.sh  

# Modify tencentddns menu index
sed -i '/腾讯云设置/i\entry({"admin", "services", "tencentddns"},cbi("tencentddns"),_("TencentDDNS"),59)' package/lean/luci-app-tencentddns/luasrc/controller/tencentddns.lua
sed -i "/腾讯云设置/,+1d" package/lean/luci-app-tencentddns/luasrc/controller/tencentddns.lua

# Modify ttnode menu index
#sed -i "s|_('甜糖星愿自动采集'), 0)\.dependent|_('甜糖星愿自动采集'), 100)\.dependent|g" package/lean/luci-app-ttnode/luasrc/controller/ttnode.lua
# fix ttnode
#sed -i 's|src="/ttnode/jquery.min.js|src="/luci-static/ttnode/jquery.min.js|' package/lean/luci-app-ttnode/luasrc/view/ttnode/login_form.htm
#sed -i '/if.*(d.error == 0)/{n;s/settime()/countdown = 60\;\n\t\t\t\t\t&/g}' package/lean/luci-app-ttnode/luasrc/view/ttnode/login_form.htm
#sed -i '/jq.cookie(.ltime., 0)/{n;s/countdown = 60/\/\/&/g}' package/lean/luci-app-ttnode/luasrc/view/ttnode/login_form.htm

# Edit theme-mcat css and js
#sed -i '/a\[data-title="Docker"\]:before/{p;N;N;d}'  feeds/kenzo/luci-theme-mcat/files/htdocs/css/style.css
#sed -i '/a\[data-title="Docker"\]:before/a\ content: "\\e025";\n color: #66CC00!important;' feeds/kenzo/luci-theme-mcat/files/htdocs/css/style.css
#sed -i "s/if (href.indexOf(nodeUrl) != -1) {/if (href.substr(href.length-nodeUrl.length,nodeUrl.length) == nodeUrl) {/g" feeds/kenzo/luci-theme-mcat/files/htdocs/js/script.js

# Edit theme-tomato css
#sed -i '/a\[data-title="Docker"\]:before/{p;N;N;d}'  feeds/kenzo/luci-theme-tomato/htdocs/luci-static/tomato/cascade.css 
#sed -i '/a\[data-title="Docker"\]:before/a\ content: "\\e025";\n color: #66CC00!important;' feeds/kenzo/luci-theme-tomato/htdocs/luci-static/tomato/cascade.css 
#sed -i "s/if (href.indexOf(nodeUrl) != -1) {/if (href.substr(href.length-nodeUrl.length,nodeUrl.length) == nodeUrl) {/g" feeds/kenzo/luci-theme-tomato/htdocs/luci-static/tomato/js/script.js

# Modify default close dhcpv6
sed -i '/dhcp.lan.\(.*$MODE\)/ s/^/# /g' package/network/services/odhcpd/files/odhcpd.defaults

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
