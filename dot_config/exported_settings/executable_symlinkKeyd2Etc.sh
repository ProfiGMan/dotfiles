#!/bin/bash

if [ -d /etc/keyd ]; then
	sudo mv /etc/keyd /etc/keyd_backup
fi

mkdir ~/.config/keyd &>/dev/null

sudo ln -s ~/.config/keyd /etc/keyd
