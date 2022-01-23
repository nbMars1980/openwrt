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

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default
#sed -i '$a src-git helloworld https://github.com/fw876/helloworld' feeds.conf.default

# Add a feed source
#git clone https://github.com/kenzok8/openwrt-packages.git feeds/kenzo
#sed -i '$a src-git kenzo https://github.com/Mars-Grace/openwrt-packages' feeds.conf.default
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
#sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default
sed -i '$a src-git xiaorouji https://github.com/xiaorouji/openwrt-passwall' feeds.conf.default

#Add bypass
#git clone https://github.com/garypang13/luci-app-bypass package/lean/luci-app-bypass

#Add ttnode
git clone https://github.com/jerrykuku/luci-app-ttnode package/lean/luci-app-ttnode

#Add dockerman
#git clone https://github.com/lisaac/luci-app-dockerman package/lean/luci-app-dockerman

#Add tencentddns
git clone https://github.com/pbx168/luci-app-tencentddns package/lean/luci-app-tencentddns
