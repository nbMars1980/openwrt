#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Add a feed source
#sed -i 's|github.com/coolsnowwolf/luci.git;.*|github.com/coolsnowwolf/luci.git|g' feeds.conf.default
sed -i '1i src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '2i src-git small https://github.com/kenzok8/small' feeds.conf.default

./scripts/feeds update -a 

rm -rf feeds/luci/applications/luci-app-mosdns feeds/luci/applications/luci-app-smartdns feeds/luci/applications/luci-app-aliyundrive-webdav feeds/luci/applications/luci-app-passwall feeds/luci/applications/luci-app-passwall2
rm -rf feeds/packages/net/{alist,adguardhome,mosdns,xray*,v2ray*,v2ray*,sing*,smartdns}
rm -rf feeds/packages/multimedia/aliyundrive-webdav 
rm -rf feeds/packages/utils/v2dat

./scripts/feeds install -a 
