#!/bin/sh -eu

service iptables stop

export GOMAXPROCS=2
/vagrant/consul/consul agent -data-dir /var/consul/data \
  -bind 192.168.33.12 -node zone2.local \
  -config-dir /vagrant/consul/consul.d \
  -retry-join 192.168.33.11 -retry-interval 5s \
  -server -bootstrap-expect 3 \
  > /vagrant/logs/zone2.log 2>&1 &

python -m SimpleHTTPServer > /dev/null 2> /dev/null &
