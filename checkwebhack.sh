#!/bin/bash


web=$1
log=$2
#web目录
#
#查找木马文件
#查找文件名
cd $web
#find ./ -name '*tunnel*'
find ./ -name '*struts*'
#find ./ -name '*upload*'

#如果木马做了免杀处理，可以查看是否使用加密函数
#find ./ -type f -name '*.php' | xargs grep 'base64_decode'
find ./ -name '*.php' -type f -print0|xargs -0 egrep '(phpspy|c99sh|milw0rm|eval\(gunerpress|eval\(base64_decode|spider_bc)'|awk -F : '{print $1}' > checkweb.log
#查看是否做了拼接处理
find ./ -type f -name '*.php' |xargs grep '@$' >>checkweb.log
#日志目录
#查找漏洞记录
#注入漏洞记录
cd $log
grep -i 'select%20' *.log  | grep 500 | grep -i \.php 
# 查找后缀为”.log” 文件，搜索关键字为”select%20″,筛选存在”500″的行
grep -i 'sqlmap' *.log 
#sqlmap默认User-Agent是sqlmap/1.0-dev-xxxxxxx (http://sqlmap.org)，查看存在sqlmap的行，可以发现sqlmap拖库的痕迹。
#跨站漏洞记录
grep -i 'script' *.log 
#查找存在script的行。

