#!/usr/bin/env bash

# do not exclude kernel* package
sed -i "s/^\(exclude=*\)/#\1/" /etc/yum.conf

# install packages
yum -y groupinstall "Development tools"
yum -y install sysstat nc wget telnet libtiff-devel libjpeg-devel libzip-devel freetype-devel lcms2-devel libwebp-devel tcl-devel tk-devel

# disable selinux
#sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
#/usr/sbin/setenforce 0

# config time zone
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# set system limits
sed -i "/# End of file/i\\* soft nofile 64000" /etc/security/limits.conf
sed -i "/# End of file/i\\* hard nofile 64000" /etc/security/limits.conf
sed -i "/# End of file/i\\* soft nproc 32000" /etc/security/limits.conf
sed -i "/# End of file/i\\* hard nproc 32000" /etc/security/limits.conf
sed -i "s/^\(*          soft    nproc     1024\)/#\1/" /etc/security/limits.d/90-nproc.conf

# config system params
sed -i '$a \\nvm.overcommit_memory=1' /etc/sysctl.conf
/sbin/sysctl -p

# config time synchronization
yum -y install ntp
/sbin/service ntpdate stop && /sbin/service ntpd start
chkconfig ntpdate off && chkconfig ntpd on

