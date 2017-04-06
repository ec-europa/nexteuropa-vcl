#!/bin/bash
[ ! -L nexteuropa ] && ln -s . nexteuropa
/usr/bin/varnishtest -p vcl_dir=$(pwd) test/*.vtc 
