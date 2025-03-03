#!/bin/bash
# Activer l'IP forwarding
echo "net.ipv4.ip_forward = 1" | tee -a /etc/sysctl.conf
sysctl -p

# Configurer iptables pour faire du NAT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT

# Sauvegarder les règles iptables
apt update && apt install -y iptables-persistent
netfilter-persistent save
netfilter-persistent reload
