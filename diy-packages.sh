./scripts/feeds update -a 

rm -rf feeds/luci/applications/luci-app-mosdns feeds/luci/applications/luci-app-smartdns feeds/luci/applications/luci-app-aliyundrive-webdav feeds/luci/applications/luci-app-passwall feeds/luci/applications/luci-app-passwall2
rm -rf feeds/packages/net/{alist,adguardhome,mosdns,xray*,v2ray*,v2ray*,sing*,smartdns}
rm -rf feeds/packages/multimedia/aliyundrive-webdav 
rm -rf feeds/packages/utils/v2dat

rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang

./scripts/feeds install -a 
