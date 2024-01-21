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

#remove passwall2
#sed -i '/passwall2/ s/^/#/g' .config

#aliyundrive-webdav 编译通不过，暂时先删除
#sed -i "s|\(aliyundrive.*\)=y|\1=n|g" .config
#nspr v4.35 编译通不过，暂时先删除
#sed -i "s/\(libnss\|PACKAGE_nspr.*\)=y/\1=n/g" .config

# Modify default IP
sed -i 's/192.168.1.1/192.168.0.250/g' package/base-files/files/bin/config_generate
# Set Display Version number
displayver=R$(date +'%y.%-m.%-d-%H%M%S')
sed -i "/DISTRIB_REVISION='R/{s|\(.\+\)'\(.\+\)'\(.\+\)|\1'$displayver Compiled by Mars'\3|;;}" package/lean/default-settings/files/zzz-default-settings
displayver=

# remove default root password
sed -i '/root\(.*\)shadow/d' package/lean/default-settings/files/zzz-default-settings

# Modify aliddns language to zh-cn
# mv feeds/kenzo/luci-app-aliddns/po/zh_Hans feeds/kenzo/luci-app-aliddns/po/zh-cn

#change  GOPROXY Set
#sed -i 's|GOPROXY=https://goproxy.io|GOPROXY=https://proxy.golang.org|g' feeds/small/*/Makefile
#sed -i 's|GOPROXY=https://goproxy.io|GOPROXY=https://proxy.golang.org|g' package/lean/UnblockNeteaseMusic-Go/Makefile

#应急修正bypass 缺少依赖ipkg 错误
#sed -i "s/+luci-lib-ipkg//g"  package/feeds/kenzo/luci-app-bypass/Makefile

#应急修正ipt2socks HASH值验证错误
#sed -i 's/73a2498dc95934c225d358707e7f7d060b5ce81aa45260ada09cbd15207d27d1/5279eb1cb7555cf9292423cc9f672dc43e6e214b3411a6df26a6a1cfa59d88b7/g' feeds/small/ipt2socks/Makefile

# modify ttnode and jd-dailybonus notify server url
sed -i "s|https://\(.*\)ftqq.com/|http://192.168.0.3:2443/|g" package/lean/luci-app-ttnode/root/usr/share/ttnode/ttnode.lua
# feeds/kenzo/luci-app-ttnode/root/usr/share/ttnode/ttnode.lua 
sed -i "s|https://\(.*\)ftqq.com/|http://192.168.0.3:2443/|g" package/lean/luci-app-jd-dailybonus/root/usr/share/jd-dailybonus/newapp.sh
# feeds/kenzo/luci-app-jd-dailybonus/root/usr/share/jd-dailybonus/newapp.sh  

# Modify tencentddns menu index
sed -i '/腾讯云设置/i\entry({"admin", "services", "tencentddns"},cbi("tencentddns"),_("TencentDDNS"),59)' package/lean/luci-app-tencentddns/luasrc/controller/tencentddns.lua
sed -i "/腾讯云设置/,+1d" package/lean/luci-app-tencentddns/luasrc/controller/tencentddns.lua

# Modify ttnode menu index
sed -i "s|_('甜糖星愿自动采集'), 0)\.dependent|_('甜糖星愿自动采集'), 100)\.dependent|g" package/lean/luci-app-ttnode/luasrc/controller/ttnode.lua
# fix ttnode
sed -i 's|src="/ttnode/jquery.min.js|src="/luci-static/ttnode/jquery.min.js|' package/lean/luci-app-ttnode/luasrc/view/ttnode/login_form.htm
sed -i '/if.*(d.error == 0)/{n;s/settime()/countdown = 60\;\n\t\t\t\t\t&/g}' package/lean/luci-app-ttnode/luasrc/view/ttnode/login_form.htm
sed -i '/jq.cookie(.ltime., 0)/{n;s/countdown = 60/\/\/&/g}' package/lean/luci-app-ttnode/luasrc/view/ttnode/login_form.htm

# Edit theme-mcat css and js
sed -i '/a\[data-title="Docker"\]:before/{p;N;N;d}'  feeds/kenzo/luci-theme-mcat/files/htdocs/css/style.css
sed -i '/a\[data-title="Docker"\]:before/a\ content: "\\e025";\n color: #66CC00!important;' feeds/kenzo/luci-theme-mcat/files/htdocs/css/style.css
sed -i "s/if (href.indexOf(nodeUrl) != -1) {/if (href.substr(href.length-nodeUrl.length,nodeUrl.length) == nodeUrl) {/g" feeds/kenzo/luci-theme-mcat/files/htdocs/js/script.js

# Edit theme-tomato css
sed -i '/a\[data-title="Docker"\]:before/{p;N;N;d}'  feeds/kenzo/luci-theme-tomato/htdocs/luci-static/tomato/cascade.css 
sed -i '/a\[data-title="Docker"\]:before/a\ content: "\\e025";\n color: #66CC00!important;' feeds/kenzo/luci-theme-tomato/htdocs/luci-static/tomato/cascade.css 
sed -i "s/if (href.indexOf(nodeUrl) != -1) {/if (href.substr(href.length-nodeUrl.length,nodeUrl.length) == nodeUrl) {/g" feeds/kenzo/luci-theme-tomato/htdocs/luci-static/tomato/js/script.js

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

#暂时删除 brook的 010-chore-deps-update-iploc-to-fix-build-with-mips.patch 补丁
#rm -rf feeds/small/brook/patches/010-chore-deps-update-iploc-to-fix-build-with-mips.patch
