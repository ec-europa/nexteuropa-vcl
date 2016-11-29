#!/bin/bash
[ ! -L nexteuropa ] && ln -s . nexteuropa
/usr/sbin/varnishd -p vcl_dir=$(pwd) -C -f testing.vcl -n /tmp 
