#!/bin/bash

TOPDIR=`pwd`

# app
install_app() {
sudo apt update
sudo apt install -y expect curl docker python3 python3-pip
}

# docker
install_docker() {
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun

/usr/bin/expect << EOF
spawn sudo pip install docker-compose
expect "password"
send "y\n"
expect eof
EOF
}

# zentao
install_zentao() {
	CURDIR=~/zentao
	[ -e $CURDIR ] && mkdir $CURDIR
	pushd $CURDIR
	mkdir $CURDIR/zentaopms
	mkdir $CURDIR/mysqldata
	docker run -d --name zentao -p 10011:80 -v `pwd`/zentaopms:/www/zentaopms -v `pwd`/mysqldata:/var/lib/mysql easysoft/zentao:17.0
	popd
	# firefox http://127.0.0.1:10011
}

# gerrit
install_gerrit() {
	CURDIR=~/gerrit
	[ -e $CURDIR ] && mkdir $CURDIR
	pushd $CURDIR
	mkdir $CURDIR/etc $CURDIR/git $CURDIR/db $CURDIR/index $CURDIR/cache
	mkdir -p $CURDIR/ldap/var $CURDIR/ldap/etc
	cp -fv $TOPDIR/gerrit/docker-compose.yml $CURDIR
	cp -fv $TOPDIR/gerrit/gerrit.config $CURDIR/etc
	cp -fv $TOPDIR/gerrit/secure.config $CURDIR/etc
	sudo docker-compose up gerrit
	popd
	# manager: firefox http://127.0.0.1:6443
	# gerrit: firefox http://127.0.0.1:8010
}
