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
sed -i 's/192.168.1.1/192.168.0.2/g' package/base-files/files/bin/config_generate
# Edit Compiled name 
sed -i  "/DISTRIB_REVISION='R/{s|\(.\+\)'\(.\+\)'\(.\+\)|\1'\2 Compiled by Mars'\3|;;}" package/lean/default-settings/files/zzz-default-settings
#sed -i "s|DISTRIB_REVISION='R\(.\+\)\.\(\w\+\)|& Compiled by Mars|" package/lean/default-settings/files/zzz-default-settings
#sed -i "s/DISTRIB_DESCRIPTION='OpenWrt/&_Mars/" package/lean/default-settings/files/zzz-default-settings

#edit dhcp config
sed -i "/exit 0/i\sed -i \"s/option start '100'/option ignore '1'/\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\sed -i \"/option limit /d\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\sed -i \"/option leasetime /d\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\sed -i \"/option ra /d\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\sed -i \"/option dhcpv6 /d\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\sed -i \"/option ndp /d\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\sed -i \"/option ra_management /d\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\sed -i \"/option ra_management /d\" /etc/config/dhcp" package/lean/default-settings/files/zzz-default-settings
#添加空行
sed -i "/exit 0/{x;p;x}" package/lean/default-settings/files/zzz-default-settings
