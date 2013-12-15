#!/usr/bin/env bash

# do not exclude kernel* package
sed -i "s/^\(exclude=*\)/#\1/" /etc/yum.conf

# install packages
yum -y groupinstall "Development tools"
yum -y install sysstat nc wget telnet

# config 163's yum repo
#mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
#cd /etc/yum.repos.d/ && wget http://mirrors.163.com/.help/CentOS6-Base-163.repo && mv CentOS6-Base-163.repo CentOS-Base.repo
#yum clean all && yum clean metadata && yum clean dbcache && yum makecache

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
sysctl vm.overcommit_memory=1
sed -i '$a \\nvm.overcommit_memory=1' /etc/sysctl.conf
sed -i '$a \\nnet.netfilter.nf_conntrack_max=131072' /etc/sysctl.conf
sed -i '$a \\nnet.netfilter.nf_conntrack_tcp_timeout_established=300' /etc/sysctl.conf
sed -i '$a \\nnet.netfilter.nf_conntrack_tcp_timeout_time_wait=120' /etc/sysctl.conf
sed -i '$a \\nnet.netfilter.nf_conntrack_tcp_timeout_close_wait=60' /etc/sysctl.conf
sed -i '$a \\nnet.netfilter.nf_conntrack_tcp_timeout_fin_wait=120' /etc/sysctl.conf
sed -i '$a \\nnet.ipv4.ip_local_port_range=10000 61000' /etc/sysctl.conf
/sbin/sysctl -p

# config time synchronization
yum -y install ntp
/sbin/service ntpdate stop && /sbin/service ntpd start
chkconfig ntpdate off && chkconfig ntpd on

