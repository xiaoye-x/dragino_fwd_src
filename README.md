# 1. Introduce.
SX1301/SX1302/SX1308 LoRaWAN concentrator driver. For devices:
- Armbian Platform: HP0A, HP0C, LPS8v2. 
- Raspberry Pi Platform: HP0D
- OpenWrt Platform: LG308, LG308N, LPS8, LPS8N, LIG16, DLOS8, DLOS8N.

# 2. How to use
## 2.1 For Armbian Platform
Git Clone in Armbian and Enter into src: run
```
./hp0z-make-deb.sh  c
```
to get deb package . 
and run 
```
dpkg -i *.deb
```
to install 

Reference Link: [Armbian Compile Instruction](http://wiki1.dragino.com/xwiki/bin/view/Main/Armbian%20OS%20instruction/#HHowtorecompileLoRaWANConcentratorDriver28dragino-fwdpackage29.)


## 2.2 For Raspberry Pi Platform

Git Clone in Armbian and Enter into src: run
```
./hp0z-make-deb.sh  d
```
to get deb package . 
and run 
```
dpkg -i *.deb
```
to install 

## 2.3 For OpenWrt Platform
See [OpenWrt compile instruction](https://github.com/dragino/openwrt_lede-18.06#how-to-develop-a-c-software-before-build-the-image)



# 3. History Before move to this github
## 2021.12.16
file: fwd/src/pkt_serv.c
remove element from dn_list when size biger than 16
remove element from dn_list when devaddr duplicated 
change the loop time of read_dir 

file: fwd/src/mac-header-decode.c 
fix bug of macMsg elemen

## 2022/02/10
file:fwd/inc/gwcfg.h
change struct serv_net_s addr leng to 256

## 2022/04/24  
version:dragino-fwd-2.3
file:/fwd/src/pkt_serv.c
1.Fix typo for Class C downlink in ABP mode. 
2.Fix FCNT initiate issue for Manually ABP Downlink.

## 2022/05/26  
Move all SX1302 src for different platform (hp0x series, pi series, lgxxx series.)  to the same github
hp0x use new station, 
lg0x series use old station



## 2022/05/26  
Fix MAX definition error in utilities and parson.h
