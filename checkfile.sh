#!/bin/bash

#set -e
#set -x



if [ -f /etc/redhat-release ]; then
	yum -y update
	yum -y install epel-release
	yum -y groupinstall 'Development Tools'
	yum install -y wget git rkhunter unhide clamav
else
	apt-get -y update
	apt-get -y install wget git build-essential rkhunter unhide clamav
fi

mkdir -p check


#rkhunter --update
nohup rkhunter -c --sk >>check/rkhunter.log 
#cp nohup.out check/rkhunter.log

nohup unhide sys >>check/unhide.log
nohup unhide brute >>check/unhide.log
nohup unhide proc >>check/unhide.log
nohup unhide procall >>check/unhide.log
nohup unhide procfs >>check/unhide.log
nohup unhide quick >>check/unhide.log
nohup unhide reverse >>check/unhide.log
nohup unhide-tcp >>check/unhide.log

freshclam
nohup clamscan -r --bell -i / >> check/clamav.log 2>&1

chkconfig --list >> check/services.log
#systemctl list-unit-files
echo '查看passwd最后修改时间'
ls -la /etc/passwd
echo '查看是否存在特权用户'
awk -F: '$3==0 {print $1}' /etc/passwd
echo '查看是否存在空口令用户'
awk -F: 'length($2)==0 {print $1}' /etc/shadow
echo '查看授权文件'
cat /root/.ssh/authorized_keys
echo '检查远程服务'
cat /etc/inetd.conf | grep -v "^#"
echo '排查计划任务'
ls -la /var/spool/cron/
ls -la /etc/cron*
echo '查看隐藏进程及端口'
cat check/unhide.log
echo '查看病毒文件'
tail -10 check/clamav.log

echo '查看恶意文件'
cat check/rkhunter.log | grep Warning
echo '查看机器服务列表'
cat check/services.log
