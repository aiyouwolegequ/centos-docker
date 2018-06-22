#!/bin/bash
export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
shell_version=v1.6
pre_install_version=1.0

dir="/usr/src/pentest/"
a1="subDomainsBrute"
a2="WhatWeb"
a3="censys"
a4="FileSensor"
a5="BingC"
a6="subbrute"
a7="N4xD0rk"
a8="dirsearch"
a9="OpenDoor"
a10="whatwaf"
a11="Sublist3r"
a12="theHarvester"
a13="bugcrowd"
a14="dnsrecon"
a15="sqlmap"
a16="ReverseIP"
a17="WPscan"

pre_check(){

	local pre_version=`cat /var/addtools/version.conf | grep pre_install_version | awk '{print $2}'`

	if [ -n "$pre_version"  ]; then
		if [ "$pre_version" != "$pre_install_version" ]; then
			sed -i "s/pre_install_version $pre_version/pre_install_version $pre_install_version/g" /var/addtools/version.conf
			echo ""
			echo "正在检测系统环境，请耐心等待..."
			pre_install
		else
			echo ""
		fi
	else
		echo "pre_install_version $pre_install_version" >> /var/addtools/version.conf
		echo ""
		echo "正在检测系统环境，请耐心等待..."
		pre_install
	fi
}

pre_install(){

	LANG="en_US.UTF-8"

	cat > /etc/profile<<-EOF
	export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
	export LC_ALL=en_US.UTF-8
	EOF

	source /etc/profile
	rm -rf /var/run/yum.pid
	yum clean all -q -y
    rm -rf /var/cache/yum
	yum-complete-transaction --cleanup-only -q
	yum history redo last -q
	yum install bind-utils curl iproute lsof mlocate net-tools policycoreutils-python python-devel python-pip python-setuptools python34 python34-devel ruby ruby-dev rubygems sysstat tar vim -q -y
	ldconfig

	if [ -n $(command -v pip) ] && [ -n $(command -v pip3) ];then
		wget -q https://bootstrap.pypa.io/get-pip.py
		python get-pip.py
		python3 get-pip.py
		rm -rf get-pip.py
	else
		python -m pip install -U pip -q
		python3 -m pip install -U pip -q
	fi

	easy_install shodan
	python -m pip install pycurl pygments dnspython gevent wafw00f censys selenium BeautifulSoup4 json2html tabulate configparser parse wfuzz feedparser greenlet -q
	python3 -m pip install scrapy docopt twisted lxml parsel w3lib cryptography pyopenssl anubis-netsec plecost json2html tabulate -q
	updatedb
	locate inittab

	cat >> /root/.zshrc<<-EOF
	alias pentest="cd /usr/src/pentest/"
	EOF

	clear
	echo "#######################################################################"
	echo ""
	echo "系统环境配置完毕..."
	echo ""
}

install_tools(){

	clear
	echo "#######################################################################"
	echo ""
	echo "开始安装渗透工具"
	echo ""
	echo "#######################################################################"
	echo "请耐心等待！"

	easy_install -q shodan

	zshalias=`grep -E "anubis | wafw00f" /root/.zshrc`

	if [ -z "$zshalias" ];then
		cat >> /root/.zshrc<<-EOF
		alias wafw00f="wafw00f -r -a -v"
		alias anubis="anubis -t -ip --with-nmap -r -d"
		EOF
	fi

	if [ ! -d "$dir$a1" ];then
		git clone -q https://github.com/lijiejie/subDomainsBrute.git $dir$a1
		cat >> /root/.zshrc<<-EOF
		alias subDomainsBrute="python /usr/src/pentest/subDomainsBrute/subDomainsBrute.py"
		EOF
	fi

	if [ ! -d "$dir$a2" ];then
		git clone -q https://github.com/urbanadventurer/WhatWeb.git $dir$a2
		cat >> /root/.zshrc<<-EOF
		alias whatweb="ruby /usr/src/pentest/WhatWeb/whatweb -v"
		EOF
	fi

	if [ ! -d "$dir$a3" ];then
		git clone -q https://github.com/gelim/censys.git $dir$a3
		pip install -r $dir$a3/requirements.txt -q
		cat >> /root/.zshrc<<-EOF
		alias censys="python /usr/src/pentest/censys/censys_io.py"
		EOF
	fi

	if [ ! -d "$dir$a4" ];then
		git clone -q https://github.com/Xyntax/FileSensor.git $dir$a4
		pip3 install -r $dir$a4/requirements.txt -q
		cat >> /root/.zshrc<<-EOF
		alias filesensor="python3 /usr/src/pentest/FileSensor/filesensor.py"
		EOF
	fi

	if [ ! -d "$dir$a5" ];then
		git clone -q https://github.com/Xyntax/BingC.git $dir$a5
		cat >> /root/.zshrc<<-EOF
		alias bingc="python /usr/src/pentest/BingC/bingC.py"
		EOF
	fi

	if [ ! -d "$dir$a6" ];then
		git clone -q https://github.com/TheRook/subbrute.git $dir$a6
		cat >> /root/.zshrc<<-EOF
		alias subdns="python /usr/src/pentest/subbrute/subbrute.py -p"
		EOF
	fi

	if [ ! -d "$dir$a7" ];then
		git clone -q https://github.com/n4xh4ck5/N4xD0rk.git $dir$a7
		cat >> /root/.zshrc<<-EOF
		alias n4xd0rk="python /usr/src/pentest/N4xD0rk/n4xd0rk.py -n 100 -t"
		EOF
	fi


	if [ ! -d "$dir$a8" ];then
		git clone -q https://github.com/maurosoria/dirsearch.git $dir$a8
		cat >> /root/.zshrc<<-EOF
		alias dirsearch="python3 /usr/src/pentest/dirsearch/dirsearch.py -u"
		EOF
	fi

	if [ ! -d "$dir$a9" ];then
		git clone -q https://github.com/stanislav-web/OpenDoor.git $dir$a9
		pip3 install -r $dir$a9/requirements-dev.txt -q
		pip3 install -r $dir$a9/requirements.txt -q
		cat >> /root/.zshrc<<-EOF
		alias opendoor="python3 /usr/src/pentest/OpenDoor/opendoor.py"
		EOF
	fi

	if [ ! -d "$dir$a10" ];then
		git clone -q https://github.com/ekultek/whatwaf.git $dir$a10
		pip install -r $dir$a10/requirements.txt -q
		cat >> /root/.zshrc<<-EOF
		alias whatwaf="python /usr/src/pentest/whatwaf/whatwaf.py"
		EOF
	fi

	if [ ! -d "$dir$a11" ];then
		git clone -q https://github.com/aboul3la/Sublist3r.git $dir$a11
		pip install -r $dir$a11/requirements.txt -q
		cat >> /root/.zshrc<<-EOF
		alias sublist3r="python /usr/src/pentest/Sublist3r/sublist3r.py -v -d"
		EOF
	fi

	if [ ! -d "$dir$a12" ];then
		git clone -q https://github.com/laramies/theHarvester.git $dir$a12
		cat >> /root/.zshrc<<-EOF
		alias theharvester="python /usr/src/pentest/theHarvester/theHarvester.py -b all -l 1000 -h -d"
		EOF
	fi

	if [ ! -d "$dir$a13" ];then
		git clone -q https://github.com/appsecco/bugcrowd-levelup-subdomain-enumeration.git $dir$a13
	fi

	if [ ! -d "$dir$a14" ];then
		git clone -q https://github.com/darkoperator/dnsrecon.git $dir$a14
		pip3 install -r $dir$a14/requirements.txt -q
		cat >> /root/.zshrc<<-EOF
		alias dnsrecon="python3 /usr/src/pentest/dnsrecon/dnsrecon.py -D /usr/src/pentest/dnsrecon/subdomains-top1mil-20000.txt -t brt"
		EOF
	fi

	if [ ! -d "$dir$a15" ];then
		git clone -q --depth 1 https://github.com/sqlmapproject/sqlmap.git $dir$a15
		cat >> /root/.zshrc<<-EOF
		alias sqlmap="python /usr/src/pentest/sqlmap/sqlmap.py"
		EOF
	fi

	if [ ! -d "$dir$a16" ];then
		mkdir -p $dir$a16
		wget -O $dir$a16/reverseip.py https://raw.githubusercontent.com/shilewareeq/Vh0s7/master/vh0s7.py
		cat >> /root/.zshrc<<-EOF
		alias reverseip="python /usr/src/pentest/ReverseIP/reverseip.py"
		EOF
	fi
	
	if [ ! -d "$dir$a17" ];then
		curl -sSL https://rvm.io/mpapis.asc | gpg --import -
		curl -sSL https://get.rvm.io | bash -s stable
		source ~/.rvm/scripts/rvm
		echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc
		rvm install 2.5.0
		rvm use 2.5.0 --default
		echo "gem: --no-ri --no-rdoc" > ~/.gemrc
		mkdir -p $dir$a17
		git clone -q https://github.com/wpscanteam/wpscan.git $dir$a17
		cd $dir$a17
		gem install bundler && bundle install --without test
		cd /usr/src/pentest/wpscan
		git pull
		ruby wpscan.rb --update
		cat >> /root/.zshrc<<-EOF
		alias wpscan="ruby /usr/src/pentest/WPscan/wpscan.rb"
		EOF
		
	fi
	
	source /root/.zshrc
	clear
	echo "#######################################################################"
	echo ""
	echo "安装完毕！工具路径为/usr/src/pentest/"
	echo ""
	echo "#######################################################################"
	echo ""
	exit
}

update(){

	echo "Check for update..."
	wget -q https://raw.githubusercontent.com/aiyouwolegequ/centos-docker/master/addtools.sh
	chmod +x addtools.sh
	local version=`grep shell_version -m1 addtools.sh | awk -F = '{print $2}'`

	if [ -f "/var/addtools/version.conf" ]; then
		local pre_version=`cat /var/addtools/version.conf | grep shell_version | awk '{print $2}'`
		if [ "$pre_version" = "$version" ]; then
			echo "no update is available - -#"
			rm -rf ./addtools.sh
		else
			if [ -f "/usr/local/bin/addtools" ]; then
				rm -rf /usr/local/bin/addtools
			fi

			mv -f addtools.sh /usr/local/bin/addtools
			echo "update success ^_^"
			sed -i "s/shell_version $pre_version/shell_version $version/g" /var/addtools/version.conf
			rm -rf ./addtools.sh
		fi
	fi
}

update_tools(){

	for i in $(ls /usr/src/pentest/ | grep -v "ReverseIP" | xargs); do
		cd /usr/src/pentest/$i
		git pull origin master
	done
}

remove(){

	rm -rf /usr/local/bin/addtools /var/addtools/version.conf
}

version(){

	echo "AddTools $shell_version"
}

usage() {

	cat >&1 <<-EOF
	Usage: addtools [option]

	[option]: (-l,list|-i,install|-u,update|-U,update-tools|-r,remove|-h,help|-v,version)

	-l,list				列出所有项目
	-i,install			安装工具
	-u,update			升级脚本到最新
	-U,update-tools		升级工具到最新
	-r,remove			卸载
	-h,help				救命啊
	-v,version			显示当前版本
	EOF

	exit $1
}

mainmenu(){

	echo "工具列表："
	echo "$a1"
	echo "$a2"
	echo "$a3"
	echo "$a4"
	echo "$a5"
	echo "$a6"
	echo "$a7"
	echo "$a8"
	echo "$a9"
	echo "$a10"
	echo "$a11"
	echo "$a12"
	echo "$a13"
	echo "$a14"
	echo "$a15"
	echo "$a16"
	echo "$a17"
}

main(){

	clear
	echo "#######################################################################"
	echo ""
	echo "addtools $shell_version"
	echo ""
	echo "#######################################################################"
	pre_check
	echo "#######################################################################"
	echo ""
	echo "(0) 退出"
	echo "(1) 部署"
	echo "(2) 更新"
	echo "(3) 卸载"
	echo ""
	echo "#######################################################################"

	read -p "请选择要执行的模块？[默认执行(1)]:" input
		if [ -z ${input} ] ; then
			input=1
		fi

	case $input in
		0)
			exit
			;;
		2)
			update
			;;
		3)
			remove
			;;
		1|*)
			install_tools
			;;
	esac
}

if [ ! -f "/usr/local/bin/addtools" ]; then
	mv -f addtools.sh /usr/local/bin/addtools
	chmod +x /usr/local/bin/addtools
fi

if [ ! -f "/var/addtools/version.conf" ]; then
	mkdir -p /var/addtools/
	touch /var/addtools/version.conf
	echo "shell_version $shell_version" > /var/addtools/version.conf
fi

action=${1:-"default"}

case ${action} in
	default)
		main
		;;
	-l|list)
		mainmenu
		;;
	-i|install)
		pre_check
		install_tools
		;;
	-u|update)
		update
		;;
	-U|update-tools)
		update_tools
		;;
	-r|remove)
		remove
		;;
	-v|version)
		version
		;;
	-h|help)
		usage 0
		;;
	*)
		usage 1
		;;
esac