#!/usr/bin/env bash
set -euo pipefail
export MAKEFLAGS="-j4"

function cmakebuild() {
  cd $1
  if [[ ! -z "${2:-}" ]]; then
    git checkout $2
  fi
  mkdir build
  cd build
  cmake ..
  make
  make install
  cd ../..
  rm -rf $1
}

cd /tmp

STATIC_PACKAGES="libusb-1.0-0"
BUILD_PACKAGES="git libusb-1.0-0-dev cmake make gcc g++ pkg-config"

apt-get update
apt-get -y install --no-install-recommends $STATIC_PACKAGES $BUILD_PACKAGES

git clone https://github.com/osmocom/rtl-sdr.git
# latest from master as of 2023-09-13 (integration of rtlsdr blog v4 dongle)
cmakebuild rtl-sdr 1261fbb285297da08f4620b18871b6d6d9ec2a7b

git clone https://github.com/pothosware/SoapyRTLSDR.git
# latest from master as of 2023-09-13
cmakebuild SoapyRTLSDR 068aa77a4c938b239c9d80cd42c4ee7986458e8f

apt-get -y purge --autoremove $BUILD_PACKAGES
apt-get clean
rm -rf /var/lib/apt/lists/*
