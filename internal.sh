#!/bin/sh -eu

cat > /etc/sysconfig/iptables <<EOT
# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8500 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
EOT

service iptables restart

export GOMAXPROCS=2
/vagrant/consul/consul agent -data-dir /var/consul/data \
  -bind 192.168.33.10 -node internal.local \
  -ui-dir /vagrant/consul/dist \
  -retry-join 192.168.33.11 -retry-interval 5s \
  > /vagrant/logs/internal.log 2>&1 &

yum install -y haproxy

cat > /etc/haproxy/haproxy.cfg <<EOT
global
  maxconn 4096
  daemon
  nbproc 2
  defaults
  mode http
  timeout client 60000
  timeout server 30000
  timeout connect 4000
  option httpclose

listen http_proxy 192.168.33.10:8500

balance roundrobin
option httpchk
option forwardfor

server c1 127.0.0.1:8500 weight 1 maxconn 512 check
EOT

service haproxy start
