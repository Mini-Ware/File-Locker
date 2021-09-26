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

  prompt

  #Convert
  tput setaf 055
  echo "Applying XOR..."
  tput setaf 255
  i=2
  n=2
  current=""
  rm $location

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
    printf "$current" >> $location
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
location=$*

#Intro
banner () {
  tput setaf 055
  printf "  __ _ _        _            _\n / _(_) | ___  | | ___   ___| | _____ _ __\n| |_| | |/ _ \ | |/ _ \ / __| |/ / _ \ '__|\n|  _| | |  __/ | | (_) | (__|   <  __/ |\n|_| |_|_|\___| |_|\___/ \___|_|\_\___|_|\n\n"
  tput setaf 255
}

#Password
prompt () {
  tput setaf 055
  echo "Give the password for your file..."
  tput setaf 255
  printf "Password: "
  read secret
  secret=$(printf "$secret" | xxd -p)
}

banner
tput setaf 055
echo "Searching for your file..."
tput setaf 255
sleep 1

#Main code
if [ $# -gt 0 ] ; then

  #Search for the file
  if [ -f "$*" ]; then
    echo "Your file has been found!"
    content=$(xxd -p $*)
    xor "$content"
  else
    echo "Your file does not exist!"
  fi

else
  echo "Missing argument!"
fi
