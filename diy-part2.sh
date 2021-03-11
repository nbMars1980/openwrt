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

# Modify default IP
sed -i 's/192.168.1.1/192.168.0.250/g' package/base-files/files/bin/config_generate
# set display version 
displayver=R$(date "+%y.%-m.%-d")
sed -i  "/DISTRIB_REVISION='R/{s|\(.\+\)'\(.\+\)'\(.\+\)|\1'$displayver Compiled by Mars'\3|;;}" package/lean/default-settings/files/zzz-default-settings
displayver=

#bypass script
find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-ssr-redir/shadowsocksr-libev-alt/g' {}
find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-ssr-server/shadowsocksr-libev-server/g' {}

#Modify theme opentomcat docker css  del 2 lines,then add 2 lines
sed -i '/a\[data-title="Docker"\]:before/{p;N;N;d}'  feeds/kenzo/luci-theme-opentomcat/files/htdocs/css/style.css
sed -i '/a\[data-title="Docker"\]:before/a\ content: "\\e025";\n color: #66CC00!important;' feeds/kenzo/luci-theme-opentomcat/files/htdocs/css/style.css

#Modify theme opentomato docker css
sed -i '/a\[data-title="Docker"\]:before/{p;N;N;d}'  feeds/kenzo/luci-theme-opentomato/htdocs/luci-static/opentomato/cascade.css
sed -i '/a\[data-title="Docker"\]:before/a\ content: "\\e025";\n color: #66CC00!important;' feeds/kenzo/luci-theme-opentomato/htdocs/luci-static/opentomato/cascade.css

#Modify theme atmaterial_Brown docker css
sed -i '/a\[data-title="Docker"\]:before/{p;N;N;d}'  feeds/kenzo/luci-theme-atmaterial/htdocs/luci-static/atmaterial_Brown/css/style.css
sed -i '/a\[data-title="Docker"\]:before/a\ content: "\\e025";\n color: #66CC00!important;' feeds/kenzo/luci-theme-atmaterial/htdocs/luci-static/atmaterial_Brown/css/style.css

#Modify theme atmaterial_red docker css
sed -i '/a\[data-title="Docker"\]:before/{n;d}'  feeds/kenzo/luci-theme-atmaterial/htdocs/luci-static/atmaterial_red/css/style.css
sed -i '/a\[data-title="Docker"\]:before/a\ content: "\\e025";' feeds/kenzo/luci-theme-atmaterial/htdocs/luci-static/atmaterial_red/css/style.css

#Modify tencentddns menu path
sed -i '/腾讯云设置/i\entry({"admin", "services", "tencentddns"},cbi("tencentddns"),_("TencentDDNS"),59)' package/lean/luci-app-tencentddns/luasrc/controller/tencentddns.lua
sed -i "/腾讯云设置/,+1d" package/lean/luci-app-tencentddns/luasrc/controller/tencentddns.lua

#Modify aliddns language to zh-cn
mv feeds/kenzo/luci-app-aliddns/po/zh_Hans feeds/kenzo/luci-app-aliddns/po/zh-cn

#move ttnode menu position to the back
sed -i "s|_('甜糖星愿自动采集'), 0)\.dependent|_('甜糖星愿自动采集'), 99)\.dependent|g" package/lean/luci-app-ttnode/luasrc/controller/ttnode.lua

#edit dhcp config
#sed -i "/exit 0/i\sed -i \"s/option start '100'/option ignore '1'/\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings
#sed -i "/exit 0/i\sed -i \"/option limit /d\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings
#sed -i "/exit 0/i\sed -i \"/option leasetime /d\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings
#sed -i "/exit 0/i\sed -i \"/option ra /d\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings
#sed -i "/exit 0/i\sed -i \"/option dhcpv6 /d\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings
#sed -i "/exit 0/i\sed -i \"/option ndp /d\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings
#sed -i "/exit 0/i\sed -i \"/option ra_management /d\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings
#添加空行
#sed -i "/exit 0/{x;p;x}" package/lean/default-settings/files/zzz-default-settings
