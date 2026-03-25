#!/bin/bash
source ~/.bash_func
title VPN
if [[ $# -eq 0 ]]; then
	input=$(zenity --forms --title="OpenFortiVPN" text="Input token" --add-entry="Token");
else
	input=$1
fi

pass=lazyS+ar80
token=$(echo $input | cut -d '|' -f2)

sudo openfortivpn -c /etc/openfortivpn/config -p "$pass" -o "$token";
