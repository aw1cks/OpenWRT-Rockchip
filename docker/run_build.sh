#!/bin/bash

set -e
export TZ='Europe/London'
let make_process=$(nproc)+1




# Presemuption: git repo present at /build/tmp
# Clean current working dir and check out fresh 21.02 src
rm -rf /build/tmp/openwrt
git clone \
  -b openwrt-21.02 \
  --single-branch \
  https://git.openwrt.org/openwrt/openwrt.git \
  /build/tmp/openwrt


# Copy build scripts
cd /build/tmp/openwrt
cp -r ../step/* ./


# Run build scripts
bash 00-prepare_openwrt.sh
bash 01-prepare_package.sh
bash 03-create_acl_for_luci.sh -a


# Copy configuration
cp ../seed/r4s.seed .config
make defconfig


# Build cross-compile toolchain
make toolchain/install -j${make_process} V=s || make toolchain/install -j1 V=s


# Build release
make -j${make_process} V=s || make -j${make_process} V=s || make -j1 V=s


# Package release
cd ..
rm -rf ./artifact
mkdir -p ./artifact
mv openwrt/bin/targets/rockchip/armv8/*sysupgrade.img* ./artifact/
cd ./artifact/
pigz -d *.gz && exit 0
pigz --best *.img
sha256sum openwrt*r4s* | tee R4S-QC-$(date +%Y-%m-%d)-21.02.sha256sum
cp ../openwrt/.config r4s.config
ls -Ahl
