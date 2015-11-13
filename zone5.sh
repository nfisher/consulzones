#!/bin/sh -eu

service iptables stop

export GOMAXPROCS=2
/vagrant/consul/consul agent -data-dir /var/consul/data \
    -bind 192.168.33.11 -node zone5.local \
    -retry-join 192.168.33.12 -retry-interval 5s \
    -server -bootstrap-expect 3 \
    > /vagrant/logs/zone5.log 2>&1 &
