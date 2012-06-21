#! /bin/bash

# layout variables
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
GREY="\033[0;37m"
COLORRESET="\033[0m"
SPACER="   "

##########################################################################################

function encrypt_file()
{
  file=$1
  filedir=${file%/*}
  filename=$(basename $file)
  tar -C $filedir -jcf $file.tbz2 $filename && openssl des3 -a -pass "env:pw" -in $file.tbz2 -out $file.encrypted && rm $file.tbz2
  return 1
}

function encrypt()
{
  prefix=$1
  
  if  [ $(find $prefix -name '*.private' | wc -l) != 0 ]; then
    echo -e "$GREEN-$COLORRESET found some private files in $prefix, start locking"
  else
    echo -e "$RED-$COLORRESET found no .private files, nothing to do"
    exit
  fi

  echo -e "$SPACER$YELLOW-$COLORRESET Requesting encryption password..."
  read -p "password: " pw
  read -p "verify  : " pw_verif
  if [ $pw != $pw_verif ]; then
    echo -e "$RED ERROR: Verification failed"
    return 1
  fi
  export pw

  for file in $(find $prefix -name '*.private'); do 
    encrypt_file $file
    echo -e "$SPACER$GREEN+$COLORRESET $file.encrypted"
  done
  return 0
}

##########################################################################################
# main execution

if [ ! -z "$1" ]; then
  prefix=$PWD/$1
else
  prefix=$PWD
fi

encrypt $prefix

