#!/bin/sh -eu

service iptables stop

export GOMAXPROCS=2
/vagrant/consul/consul agent -data-dir /var/consul/data \
    -bind 192.168.33.11 -node zone5.local \
    > /vagrant/logs/zone5.log 2>&1 &
