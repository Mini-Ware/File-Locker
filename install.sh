#!/bin/bash
blue=$'\e[0;34m'
green=$'\e[0;32m'
white=$'\e[0m'
echo "NOTE: if this script does not seem to install, please check if the alias is already used by bash"
function install() { 
	echo "$blue[*]$white installing..."
	sleep 0.5
	sudo cp run.sh /bin/$1
	check
	sudo chmod +x /bin/$1
	check
	echo $green"[*]"$white" installation complete!"
	exit 0;
}
function check() {
	if [ ! $? -eq 0 ];
	then
		echo "something went wrong... quitting!"
		exit $?
	fi
}
default="XOR-bash"
echo "what is the command you want to use to call the script?"
echo "leave blank to use the default installation name"
echo "["$blue"Default:$green XOR-bash"$white"]"
read -p "$blue command$green>$white" name
if [ -z $name ]
then
	echo "No input, using $default!"
	install $default
fi
if [ -f /bin/$name ]
then
	echo "ERROR! command $name already exists! do you want to continue?"
	read -p $blue"Y$green/n$white>" cont
	if [ -z $cont ]
	then
		echo "No input detected! quitting!"
		exit 1
	fi
	shopt -s nocasematch
	if [[ $cont == "n" ]]
	then
		echo "quitting installation!"
		exit 1
	fi
fi
install $name
