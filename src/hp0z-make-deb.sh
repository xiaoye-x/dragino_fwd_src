#!/bin/bash

VER=$(date -u '+%Y-%m-%d')

[[ -z $1 ]] && exit 1

## rassberry pi use hp0d

case "$1" in 
    "d")
        board="hp0d"
        ;;
    "c")
        board="hp0c"
        ;;
    "r")
        board="rasb"
        ;;
    *)
        board="hp0c"
        ;;
esac

if [[ "$board" = "rasb" ]]; then
    echo "start compile libmpsse..."
    make all -e -C libmpsse  || exit 1
    make install  -C libmpsse  || exit 1
    echo "start compile fwd..."
    make -f makefile-hp0z RASBMOD=1 ||  exit 1
else
    echo "start compile fwd..."
    make -f makefile-hp0z  ||  exit 1
fi

echo "start make deb package..."

echo "FWD build succeed, start make deb package..."

echo "deb version: draginofwd-${VER}"

rm -rf pi_pkg
rm -rf draginofwd-*.deb

sed -i "s/^.*VER=.*/VER=\"${VER}\"/" DEBIAN/postinst
sed -i "s/^.*Version:.*/Version: ${VER}/" DEBIAN/control
mkdir -p pi_pkg/lib/systemd/system
mkdir -p pi_pkg/etc/lora

if [[ "$board" = "hp0c" ]]; then
    cp -f config/hp0c-global_conf.json pi_pkg/etc/lora/global_conf.json
else
    cp -f config/hp0d-global_conf.json pi_pkg/etc/lora/global_conf.json
fi

cp -f config/local_conf.json pi_pkg/etc/lora

cp -rf DEBIAN pi_pkg/
cp -rf draginofwd.service pi_pkg/lib/systemd/system

install -d pi_pkg/usr/lib
install -m 755 libmqtt/libpahomqtt3c.so pi_pkg/usr/lib/libpahomqtt3c.so
install -m 755 sx1302hal/libsx1302hal.so pi_pkg/usr/lib/libsx1302hal.so
install -d pi_pkg/usr/bin
install -m 755 sx1302hal/test_loragw_hal_rx pi_pkg/usr/bin/rx_test
install -m 755 sx1302hal/test_loragw_hal_tx pi_pkg/usr/bin/tx_test
install -m 755 sx1302hal/test_loragw_toa pi_pkg/usr/bin/toa_test
install -m 755 sx1302hal/test_loragw_com pi_pkg/usr/bin/com_test
install -m 755 sx1302hal/test_loragw_com_sx1250 pi_pkg/usr/bin/sx1250_test
install -m 755 build_fwd_sx1302/fwd_sx1302 pi_pkg/usr/bin
install -m 755 build_station_sx1302/build-mips-openwrt-dragino/bin/station_sx1302 pi_pkg/usr/bin
if [[ "$board" = "hp0c" ]]; then
    install -m 755 tools/reset_lgw-hp0c.sh pi_pkg/usr/bin/reset_lgw.sh
else
    install -m 755 tools/reset_lgw-hp0d.sh pi_pkg/usr/bin/reset_lgw.sh
fi
if [[ "$board" = "rasb" ]]; then
    install -m 755 sx1301hal/libsx1301hal.so pi_pkg/usr/lib/libsx1301hal.so
    install -m 755 build_fwd_sx1301/fwd_sx1301 pi_pkg/usr/bin
    install -m 755 build_station_sx1301/build-mips-openwrt-dragino/bin/station_sx1301 pi_pkg/usr/bin
fi
ln -sf /usr/bin/fwd_sx1302 pi_pkg/usr/bin/fwd
dpkg-deb -Zgzip -b pi_pkg draginofwd-${VER}.deb

rm -rf pi_pkg

