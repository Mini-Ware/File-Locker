#!/bin/bash

#Functions
xor () {
  tput setaf 055
  echo "Reading the contents of your file..."
  tput setaf 255
  x=$*

  #Remove spaces
  filter=$(echo "$x" | tr -d '\n')
  sleep 1
  echo "Your file has been analysed!"

  #Convert
  tput setaf 055
  echo "Applying XOR..."
  tput setaf 255
  i=2
  n=2
  current=""
  rm -f $location

  while [ $i -le ${#filter} ]
  do
    if [ ${filter:i-2:2} == "48" ]
    then
      current=$(echo $(("0x00 ^ 0x${secret:n-2:2}")))
    else
      current=$(echo $(("0x${filter:i-2:2} ^ 0x${secret:n-2:2}")))
    fi

    #Line Feed
    if [ $current -eq 10 ]
    then
      current="\n"
    else

      #Null byte
      if [ $current -eq 0 ]
      then
        current=72
      fi
      current=$(printf "%x" $current)

      if [ ${#current} -le 1 ]
      then
        current=$(echo "0$current")
      fi
      current=$(echo $current | xxd -p -r)
    fi

    #Redirect
    printf "$current" >> "$location"
    let i=i+2
    let n=n+2

    if [ $n -ge ${#secret} ]
    then
      let n=0
    fi

  done
  echo "Your file has been processed!"
}

#Variables
content=""

#Intro
banner () {
  tput setaf 055
  printf "  __ _ _        _            _\n / _(_) | ___  | | ___   ___| | _____ _ __\n| |_| | |/ _ \ | |/ _ \ / __| |/ / _ \ '__|\n|  _| | |  __/ | | (_) | (__|   <  __/ |\n|_| |_|_|\___| |_|\___/ \___|_|\_\___|_|\n\n"
  tput setaf 1
  echo "WARNING!: if you exit the program while it's running, your files may be deleted!"
  tput setaf 255
}

#Password
prompt () {
  tput setaf 055
  echo "Give the password for your file..."
  tput setaf 255
  read -s -p "Password: " secret
  echo ""
  read -s -p "Re-enter password: " check_secret
  echo ""
  if [[ $secret != $check_secret ]]
  then
	  echo "Passwords do not match!"
	  prompt
  else
	  secret=$(printf "$secret" | xxd -p)
  fi
}

banner
tput setaf 055
echo "Searching for your file(s)..."
tput setaf 255
sleep 1

#Main code
declare -a dir
declare -a file
#sort arguments for files and directories
while [ ! -z $1 ]
do
	if [ -d $1 ]
	then	
		dir+=($1)
		shift
		continue
	elif [ -f $1 ]
	then
		file+=($1)
		shift 
		continue
	fi
	echo "ERROR: $1 is not a file OR directory, skipping..."
	shift
done
#check for files and directories
if [[ -z $dir && -z $file ]]
then
	echo "ERROR: no file AND directory found!"
	exit 1
fi
tput setaf 130
echo "total directories to be XOR'd: ${#dir[@]}"
echo "total files to be XOR'd: ${#file[@]}"
tput setaf 255

prompt

e=0

if [ ! -z $file ]
then
	tput setaf 055
	echo "XOR'ng files... this may take a while"
	tput setaf 255
	while [ $e -lt ${#file[@]} ]
	do
		location=${file[$e]}
		content=$(xxd -p ${file[$e]})
		xor "$content"
		e=$[$e+1]
	done
	tput setaf 055
	echo "files XOR'd!"
	tput setaf 255
fi

e=0

if [ ! -z $dir ]
then
	echo "XOR'ng directories... this may take a while"
	while [ $e -lt ${#dir[@]} ]
	do
		for f in ${dir[$e]}*
		do
			if test -f "$f"
			then
				location=$f
				content=$(xxd -p $f)
				xor "$content"
			fi
		done
		e=$[$e+1]
	done
	echo "directories XOR'd!"
fi

echo "all files XOR'd, have a nice day!"
