#!/bin/bash

TMP_RESOURCE=/var/tmp_resource
BOOTSTRAP_ID=d01c72e6-83f4-4a19-bb86-6085e40416e6

stty erase '^H'

# 标准化输出
print(){
        echo -e "\033[44;37m [TIP]: $* \033[0m"
}

# 显示进度条
show_progress(){
        start=$1
        end=$2
        for ((i=${start};$i<=${end};i+=2))
        do
		echo -en "\033[44;37m"
                printf " [WHOLE PROGRESS]:[%-50s]%d%%\r" $x $i
        	sleep 0.1
        	x=#$x
        done
 	echo -e "\e[1;30;m"
}

# 预设置
pre_setting(){
        print "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        print "Pre settings...................................................."

        # set time zone
        ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
        print "1).Local timezone setting OK!..................................."

        # set time manually
        print "Please input the current time with format <yyyy-MM-dd HH:mm:ss>:"
        read -p "Your time is (e.g. 2018-01-01 09:34:21) ----------->>>" time
        date -s "${time}" 2>/dev/null >/dev/null
        hwclock -w
        print "2).Mannual time setting OK!....................................."

        print "Pre settings OK!................................................"
        show_progress 0 10
}

# 解压资源文件
decompress(){
        print "+++++++++++++++++++++++++++++"
        print "Extract installation files..."
        mkdir -p ${TMP_RESOURCE}
        tail -n +165 fuel_build_local-9.0.run > ${TMP_RESOURCE}/local_resource-9.0.tar
        tar -xvf ${TMP_RESOURCE}/local_resource-9.0.tar -C ${TMP_RESOURCE} 2>/dev/null >/dev/null
	print "Extract installation files OK!"
	show_progress 10 30
}

# 设置本地源Bootstrap
setLocalBootstrap(){
        print "++++++++++++++++++++++"
        print "Set local bootstrap..."

	# back up
        mv /var/www/nailgun/bootstraps /var/www/nailgun/bootstraps.bak     

	# unzip and move local bootstrap file to dir
	tar -xvf ${TMP_RESOURCE}/bootstraps.tar -C /var/www/nailgun/ 2>/dev/null >/dev/null
        mv /var/www/nailgun/bootstraps/active_bootstrap/ /var/www/nailgun/bootstraps/bootstrap_stub/

        # active bootstrap
	fuel-bootstrap activate ${BOOTSTRAP_ID} 2>/dev/null >/dev/null
	print "Set local bootstrap OK!"
	show_progress 30 50
}

# 设置本地源Mirror
setLocalMirror(){
	print "+++++++++++++++++++"
        print "Set local mirror..."	

	# unzip and move local mirror file to dir
        tar -xvf ${TMP_RESOURCE}/mirrors.tar -C /var/www/nailgun 2>/dev/null >/dev/null

	# active mirror
	fuel-createmirror 2>/dev/null >/dev/null
	print "Set local mirror OK!"
	show_progress 50 70
}

# 默认插件安装
pluginsInstall(){
        print "++++++++++++++++++++++++++"
        print "Install default plugins..."
	
	# unzip and move plugins file to dir
        tar -xvf ${TMP_RESOURCE}/plugins.tar -C /tmp/ 2>/dev/null >/dev/null

	# install plugins
        fuel plugins --install /tmp/ceilometer-redis-1.0-1.0.3-1.noarch.rpm 2>/dev/null >/dev/null	
	fuel plugins --install /tmp/detach-rabbitmq-1.1-1.1.2-1.noarch.rpm 2>/dev/null >/dev/null
	fuel plugins --install /tmp/elasticsearch_kibana-1.0-1.0.0-1.noarch.rpm 2>/dev/null >/dev/null
	fuel plugins --install /tmp/fuel-plugin-manila-1.0-1.0.0-1.noarch.rpm 2>/dev/null >/dev/null
	fuel plugins --install /tmp/influxdb_grafana-1.0-1.0.0-1.noarch.rpm 2>/dev/null >/dev/null
	fuel plugins --install /tmp/kafka-1.0-1.0.0-1.noarch.rpm 2>/dev/null >/dev/null
	fuel plugins --install /tmp/lbaas-1.0-1.0.3-1.noarch.rpm 2>/dev/null >/dev/null
	fuel plugins --install /tmp/ldap-3.0-3.0.2-1.noarch.rpm 2>/dev/null >/dev/null
	fuel plugins --install /tmp/lma_collector-1.0-1.0.0-1.noarch.rpm 2>/dev/null >/dev/null
	fuel plugins --install /tmp/lma_infrastructure_alerting-1.0-1.0.0-1.noarch.rpm 2>/dev/null >/dev/null
	fuel plugins --install /tmp/telemetry-1.0-1.0.1-1.noarch.rpm 2>/dev/null >/dev/null
	fuel plugins --install /tmp/zabbix_monitoring-2.5-2.5.2-1.noarch.rpm 2>/dev/null >/dev/null
	fuel plugins --install /tmp/zabbix_snmptrapd-1.1-1.1.1-1.noarch.rpm 2>/dev/null >/dev/null

	print "Install default plugins OK!"
	show_progress 70 80
}

# 后设置
post_setting(){
        print "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        print "Post settings..................................................."

        # set target node's deployment timezone through fuel settings
        sed -i 's/TIMEZONE: \"Etc\/UTC\"/TIMEZONE: \"Asia\/Shanghai\"/g' /usr/lib/python2.7/site-packages/nailgun/settings.yaml
        systemctl restart nailgun
        print "1).Target timezone setting OK!..................................."

        print "Post settings OK!..............................................."
        show_progress 80 90
}

# 删除临时资源文件
clean_resource(){
        print "++++++++++++++++++++++++++++++"
        print "Clean the tmp resource file..."
        rm -fr ${TMP_RESOURCE}
	print "Clean the tmp resource file OK!"
	show_progress 90 100
}

print "==============================================================================================="
print ""
print "+++++++++++++++++++++++++++++++++++ FUEL BUILD LOCAL - 9.0 ++++++++++++++++++++++++++++++++++++"
print ""
print "==============================================================================================="

print "#####################################################################"
print "NOTICE: The progress will last at least 10 minutes.Please be patient!"
print "#####################################################################"

pre_setting
decompress
setLocalBootstrap
setLocalMirror
pluginsInstall
post_setting
clean_resource

print "==============================================================================================="
print ""
print "+++++++++++++++++++++++++++++++++++ FUEL BUILD LOCAL - 9.0 ++++++++++++++++++++++++++++++++++++"
print ""
print "==============================================================================================="

exit 0 
