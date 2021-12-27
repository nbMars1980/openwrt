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
./scripts/feeds uninstall smartdns 
./scripts/feeds install -fp kenzo smartdns luci-app-jd-dailybonus
./scripts/feeds install -fp small trojan simple-obfs dnsproxy

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

# Modify tencentddns menu index
sed -i '/腾讯云设置/i\entry({"admin", "services", "tencentddns"},cbi("tencentddns"),_("TencentDDNS"),59)' package/lean/luci-app-tencentddns/luasrc/controller/tencentddns.lua
sed -i "/腾讯云设置/,+1d" package/lean/luci-app-tencentddns/luasrc/controller/tencentddns.lua

# Modify ttnode menu index
sed -i "s|_('甜糖星愿自动采集'), 0)\.dependent|_('甜糖星愿自动采集'), 100)\.dependent|g" package/lean/luci-app-ttnode/luasrc/controller/ttnode.lua

# Edit theme-mcat css
sed -i '/a\[data-title="Docker"\]:before/{p;N;N;d}'  feeds/kenzo/luci-theme-mcat/files/htdocs/css/style.css
sed -i '/a\[data-title="Docker"\]:before/a\ content: "\\e025";\n color: #66CC00!important;' feeds/kenzo/luci-theme-mcat/files/htdocs/css/style.css

# Edit theme-tomato css
sed -i '/a\[data-title="Docker"\]:before/{p;N;N;d}'  feeds/kenzo/luci-theme-tomato/htdocs/luci-static/tomato/cascade.css 
sed -i '/a\[data-title="Docker"\]:before/a\ content: "\\e025";\n color: #66CC00!important;' feeds/kenzo/luci-theme-tomato/htdocs/luci-static/tomato/cascade.css 

# Edit theme-atmaterial_Brown css
#sed -i '/a\[data-title="Docker"\]:before/{p;N;N;d}'  feeds/kenzo/luci-theme-atmaterial/htdocs/luci-static/atmaterial_Brown/css/style.css
#sed -i '/a\[data-title="Docker"\]:before/a\ content: "\\e025";\n color: #66CC00!important;' feeds/kenzo/luci-theme-atmaterial/htdocs/luci-static/atmaterial_Brown/css/style.css

# Edit theme-atmaterial_red css
#sed -i '/a\[data-title="Docker"\]:before/{p;N;d}'  feeds/kenzo/luci-theme-atmaterial/htdocs/luci-static/atmaterial_red/css/style.css
#sed -i '/a\[data-title="Docker"\]:before/a\ content: "\\e025";' feeds/kenzo/luci-theme-atmaterial/htdocs/luci-static/atmaterial_red/css/style.css

# Fix bypass not run also stop end disable smartdns
sed  -i 's|\"$(uci -q get smartdns.@smartdns\[0\].enabled)\" == \"1\"|\"$(uci -q get smartdns.@smartdns\[0\].enabled)\" == \"1\" \]\] \&\& \[\[ \"$(uci -q get bypass.@global\[0\].global_server)\" != \"\"|g' package/lean/luci-app-bypass/luci-app-bypass/root/etc/init.d/bypass
#find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-ssr-redir/shadowsocksr-libev-alt/g' {}
#find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-ssr-server/shadowsocksr-libev-server/g' {}
#find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/smartdns-le/smartdns/g' {}


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
