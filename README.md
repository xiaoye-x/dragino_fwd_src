##2021.12.16
file: fwd/src/pkt_serv.c
remove element from dn_list when size biger than 16
remove element from dn_list when devaddr duplicated 
change the loop time of read_dir 

file: fwd/src/mac-header-decode.c 
fix bug of macMsg elemen

##2022/02/10
file:fwd/inc/gwcfg.h
change struct serv_net_s addr leng to 256

##2022/04/24  
version:dragino-fwd-2.3
file:/fwd/src/pkt_serv.c
1.拼写错误，自定义CLASSC下发时，将nwkskey写成了devaddr
2.自定义下发的fcnt初始化时为0，应该初始化为1，自定义下发的记录数递增的最大值是 32位无符号数

##2022/05/26  
将所有board的fwd统一在一起（hp系列，pi系列，lg系列）
hp系列使用新的station, lg系列使用原来旧的station

lg系列编译方法不变

pi和hp系列进入src目录编译

编译hpod的fwd： ./hp0z-make-deb.sh  d
编译hpoc的fwd： ./hp0z-make-deb.sh  c
rasspberrypi:   ./hp0z-make-deb.sh  d

编译出来的是 deb 包, 需要装时运行: dpkg -i *.deb

##2022/05/26  
修改utilities和parson.h里的MAX重复定义的错误
