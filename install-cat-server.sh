#!/bin/bash

set -x

install_depend() {
	apt update && \
	apt install -y openjdk-11-jre-headless && \
	apt install -y openjdk-11-jdk
}

gen_systemd_service() {
    CMD=teamserver
    cat > /etc/systemd/system/cat-server.service << EOF
[Unit]
Description=CatServer

[Service]
Type=simple
WorkingDirectory=${WorkingDirectory}
ExecStart=${WorkingDirectory}/${CMD}
KillMode=mixed
Restart=always
RestartSec=1

[Install]
WantedBy=multi-user.target
EOF
}

gen_catserver_config() {
	IP="$(curl ip.sb)"
	cat > ${WorkingDirectory}/CatServer.properties << EOF
CatServer.Version = 1.1
CatServer.port = 5000
CatServer.store = feifeibufei.store
CatServer.store-password = zjUFG6ITfHtgsT
CatServer.host = $IP
CatServer.password = mhxzkhl9521
CatServer.profile-name = admin
CatServer.profile = test.profile
CatServer.auth = false
CatServer.authlog = false
CatServer.googleauth = false
CatServer.googlekey = YOTPPRZ4RQ75QNKKE65GXE6BQBSQDVQJ
CatServer.safecode = MkbY0wttL86Z8

CatServer.Iv = abcdefghijklmnop

stager.checksum-num = 400
stager.x86-num = 100
stager.x86-uri-len = 6
stager.x64-num = 105
stager.x64-uri-len = 8
EOF
} 

main() {
	WorkingDirectory="/usr/local/cat-server"
	install_depend
	
	# download_cat_server
    if [ -d ${WorkingDirectory} ];then
		# directory already exists
		systemctl stop cat-server.service
        rm -rf ${WorkingDirectory}/*
	else
		mkdir ${WorkingDirectory}
    fi
    curl https://raw.githubusercontent.com/fm7u4n/cat-server/main/CS4.5/cat_server.tar -o /tmp/cat-server.tar
    tar -xvf /tmp/cat-server.tar -C ${WorkingDirectory} --strip-components=1
	rm /tmp/cat-server.tar

	chmod +x ${WorkingDirectory}/teamserver

	gen_catserver_config && \
	gen_systemd_service && \
	systemctl daemon-reload && \
	systemctl enable cat-server.service && \
	systemctl start cat-server.service

	echo "Installation complete"
}

main $@
