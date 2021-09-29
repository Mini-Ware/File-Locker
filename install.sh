#!/bin/bash
blue=$'\e[0;34m'
green=$'\e[0;32m'
white=$'\e[0m'
echo "NOTE: If this script does not seem to install, please check if the alias is already used by bash"
function install() { 
	echo "$blue[*]$white Installing..."
	sleep 0.5
	sudo cp run.sh /bin/$1
	check
	sudo chmod +x /bin/$1
	check
	echo $green"[*]"$white" Installation complete!"
	exit 0;
}
function check() {
	if [ ! $? -eq 0 ];
	then
		echo "Something went wrong... Quitting!"
		exit $?
	fi
}
default="fl"
echo "What is the custom command name you want to use to call the script?"
echo "(Leave blank to use the default installation name)"
echo "["$blue"Default:$green XOR-bash"$white"]"
read -p "$blue Command$green>$white" name
if [ -z $name ]
then
	echo "No input, using $default!"
	install $default
fi
if [ -f /bin/$name ]
then
	echo "ERROR! Command $name already exists! Do you want to continue?"
	read -p $blue"Y$green/n$white>" cont
	if [ -z $cont ]
	then
		echo "No input detected! Quitting!"
		exit 1
	fi
	shopt -s nocasematch
	if [[ $cont == "n" ]]
	then
		echo "Quitting installation!"
		exit 1
	fi
fi
install $name
