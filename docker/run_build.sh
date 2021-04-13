#!/bin/bash

set -e
export TZ='Europe/London'
let make_process=$(nproc)+1




# Presemuption: git repo present at /build/tmp
rm -rfv /build/tmp/openwrt
git clone \
  -b openwrt-21.02 \
  --single-branch \
  https://git.openwrt.org/openwrt/openwrt.git \
  /build/tmp/openwrt


cd /build/tmp/openwrt
cp -r ../step/* ./


bash 00-prepare_openwrt.sh
bash 01-prepare_package.sh
bash 03-create_acl_for_luci.sh -a


cp ../seed/rockchip.seed .config
make defconfig
cp .config rockchip_multi.config


make toolchain/install -j${make_process} V=s || make toolchain/install -j1 V=s


make -j${make_process} V=s || make -j${make_process} V=s || make -j1 V=s


cd ..
rm -rfv ./artifact
mkdir -p ./artifact
mv openwrt/bin/targets/rockchip/armv8/*sysupgrade.img* ./artifact/
cd ./artifact/
ls -Ahl
pigz -d *.gz && exit 0
pigz --best *.img
ls -Ahl
sha256sum openwrt*r4s* | tee R4S-QC-$(date +%Y-%m-%d)-21.02.sha256sum
zip R4S-QC-$(date +%Y-%m-%d)-21.02-ext4.zip *r4s*ext4*
zip R4S-QC-$(date +%Y-%m-%d)-21.02-sfs.zip *r4s*squashfs*
cp ../openwrt/*.config ./
ls -Ahl
