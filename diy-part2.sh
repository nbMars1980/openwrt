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
# Set Display Version number
displayver=R$(date +'%y.%-m.%-d-%H%M%S')
sed -i "/DISTRIB_REVISION='R/{s|\(.\+\)'\(.\+\)'\(.\+\)|\1'$displayver Compiled by Mars'\3|;;}" package/lean/default-settings/files/zzz-default-settings
displayver=

# Modify aliddns language to zh-cn
mv feeds/kenzo/luci-app-aliddns/po/zh_Hans feeds/kenzo/luci-app-aliddns/po/zh-cn

# Modify tencentddns menu index
sed -i '/腾讯云设置/i\entry({"admin", "services", "tencentddns"},cbi("tencentddns"),_("TencentDDNS"),59)' package/lean/luci-app-tencentddns/luasrc/controller/tencentddns.lua
sed -i "/腾讯云设置/,+1d" package/lean/luci-app-tencentddns/luasrc/controller/tencentddns.lua

# Modify ttnode menu index
sed -i "s|_('甜糖星愿自动采集'), 0)\.dependent|_('甜糖星愿自动采集'), 100)\.dependent|g" package/lean/luci-app-ttnode/luasrc/controller/ttnode.lua

# Edit theme-opentomcat css
sed -i '/a\[data-title="Docker"\]:before/{p;N;N;d}'  feeds/kenzo/luci-theme-opentomcat/files/htdocs/css/style.css
sed -i '/a\[data-title="Docker"\]:before/a\ content: "\\e025";\n color: #66CC00!important;' feeds/kenzo/luci-theme-opentomcat/files/htdocs/css/style.css

# Edit theme-opentomato css
sed -i '/a\[data-title="Docker"\]:before/{p;N;N;d}'  feeds/kenzo/luci-theme-opentomato/htdocs/luci-static/opentomato/cascade.css 
sed -i '/a\[data-title="Docker"\]:before/a\ content: "\\e025";\n color: #66CC00!important;' feeds/kenzo/luci-theme-opentomato/htdocs/luci-static/opentomato/cascade.css 

# Edit theme-atmaterial_Brown css
sed -i '/a\[data-title="Docker"\]:before/{p;N;N;d}'  feeds/kenzo/luci-theme-atmaterial/htdocs/luci-static/atmaterial_Brown/css/style.css
sed -i '/a\[data-title="Docker"\]:before/a\ content: "\\e025";\n color: #66CC00!important;' feeds/kenzo/luci-theme-atmaterial/htdocs/luci-static/atmaterial_Brown/css/style.css

# Edit theme-atmaterial_Brown css
sed -i '/a\[data-title="Docker"\]:before/{p;N;d}'  feeds/kenzo/luci-theme-atmaterial/htdocs/luci-static/atmaterial_red/css/style.css
sed -i '/a\[data-title="Docker"\]:before/a\ content: "\\e025";' feeds/kenzo/luci-theme-atmaterial/htdocs/luci-static/atmaterial_red/css/style.css

# Fix bypass relys
find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-ssr-redir/shadowsocksr-libev-alt/g' {}
find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-ssr-server/shadowsocksr-libev-server/g' {}
find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/smartdns-le/smartdns/g' {}

# Test code
# Modify network default config
sed -i "/DISTRIB_DESCRIPTION=/a\\\nsed -i '/option ula_prefix/d' /etc/config/network" package/lean/default-settings/files/zzz-default-settings

# Modify network default dhcp config
sed -i "/DISTRIB_DESCRIPTION=/a\sed -i \"/option start/d\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings
sed -i "/DISTRIB_DESCRIPTION=/a\sed -i \"/option limit/d\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings
sed -i "/DISTRIB_DESCRIPTION=/a\sed -i \"/option leasetime/d\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings
sed -i "/DISTRIB_DESCRIPTION=/a\sed -i \"/option\x5c(.*'server'\x5c)/d\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings
sed -i "/DISTRIB_DESCRIPTION=/a\sed -i \"/option ra_management/d\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings
sed -i "/DISTRIB_DESCRIPTION=/a\\\nsed -i \"/option start/i\x5c \x5ctoption ignore '1'\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings

