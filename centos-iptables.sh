#!/usr/bin/env bash

iptables -P INPUT ACCEPT
iptables -F

iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT

iptables -A INPUT -m state --state ESTABLISHED,RELATED,UNTRACKED -j ACCEPT
iptables -A FORWARD -m state --state UNTRACKED -j ACCEPT

# ssh
iptables -A INPUT -m state --state NEW -p tcp --dport 22 -j ACCEPT

# http
#iptables -t raw -A PREROUTING -p tcp -m multiport --dport 80,443 -j NOTRACK

iptables -P INPUT DROP 
iptables -P FORWARD DROP 
iptables -P OUTPUT ACCEPT 

service iptables save
iptables -L -v 
