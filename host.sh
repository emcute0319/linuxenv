#!/bin/bash

source common.sh

TOPDIR=`pwd`
HOME=`realpath ~`

# app
install_app() {
	sudo apt install -y curl wget expect unzip git
	sudo apt install -y zsh
	sudo apt install -y tmux
	sudo apt install -y vim
	sudo apt install -y lua5.3 python3 python3-pip nodejs npm
}

# proxy
install_proxy() {
	msg "Install Proxy Start"
	mkdir -p ~/bin
	unzip $TOPDIR/backup/v2ray-linux-64.zip -d ~/bin/v2ray
	cp -fv $TOPDIR/configs/v2ray-config.json ~/bin/v2ray/config.json
	~/bin/v2ray/v2ray run --config=$HOME/bin/v2ray/config.json &
	
	export http_proxy=http://127.0.0.1:10809
	export https_proxy=http://127.0.0.1:10809
	
	ret="$?"
	success "Install Proxy Successfully"
}

# zsh
install_zsh() {
	msg "Install Zsh Start"

/usr/bin/expect << EOF

#log_user 1
#exp_internal 1

set time 300
spawn sh -c {$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)}
expect {
"Y/n" { send "no\r" } 
} 
expect eof

EOF

	ret="$?"
	success "Install Zsh Successfully"
}

# tmux
install_tmux() {
	msg "Install Tmux Start"
	git clone https://github.com/gpakosz/.tmux.git ~/.oh-my-tmux
	ln -s -f ~/.oh-my-tmux/.tmux.conf ~/.tmux.conf
	cp ~/.oh-my-tmux/.tmux.conf.local ~/.tmux.conf.local
	ret="$?"
	success "Install Tmux Successfully"
}

# vim
install_vim() {
	msg "Install Vim Start"
	
	curl https://j.mp/spf13-vim3 -L -o - | sh
	
	ret="$?"
	success "Install Tmux Successfully"
}

# nvim
install_nvim() {
	msg "Install Nvim Start"
	
	wget https://github.com/neovim/neovim/releases/download/v0.8.0/nvim-linux64.deb
	
	sudo apt install ./nvim-linux64.deb
	rm -fv ./nvim-linux64.deb
	
	git clone https://gitlab.com/emcute0319/nvim.git $HOME/.config/nvim
	nvim +PackInstall!
	
	ret="$?"
	success "Install Nvim Successfully"
}

# joplin+onedrive
install_note() {
	msg "Install Joplin and Onedrive"
	
	wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
}

# main
main() {
	msg "Host Install Start"
	install_app
	install_proxy
	install_zsh
	install_tmux
	install_vim
	install_nvim
	ret="$?"
	success "Host Install End"
}

main
