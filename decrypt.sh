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

###############################################################################################

function absolute_path()
{
  # remove trailing slash
  path=$( echo "$1" | sed -e "s/\/*$//" )
  # make absolute
  [ "${path/#\//}" != "$path" ] || path="$PWD/$path"
  # return
  echo $path
}

###############################################################################################

function command_exists() 
{ 
  type "$1" &> /dev/null
}

##########################################################################################

function decrypt_file()
{
  file=$1
  filedir=${file%/*}
  rm -rf ${file%.encrypted}
  openssl des3 -a -d -pass "env:pw" -in $file -out ${file%.encrypted}.tbz2 > /dev/null 2>&1 && tar -C $filedir -jxf ${file%.encrypted}.tbz2 > /dev/null 2>&1 && rm ${file%.encrypted}.tbz2
  if [ ! -e "${file%.encrypted}" ]; then
    return 1
  fi
  return 0
}


function decrypt()
{
  prefix=$1

  if  [ $(find $prefix -name '*.encrypted' | wc -l) != 0 ]; then
    echo -e "$GREEN-$COLORRESET found some encrypted files in $prefix, start decrypting"
  else
    echo -e "$RED-$COLORRESET found no .encrypted files, nothing to decrypt"
    exit 0
  fi

  echo -e "$SPACER$YELLOW-$COLORRESET Requesting decryption password... Empty password will ignore decryption"
  read -p "password: " pw
  case $pw in
    "")
      echo -e "$SPACER$YELLOW-$COLORRESET Ignoring decryption"
      return 1
      ;;
    *)
      if ! command_exists openssl; then 
        echo -e "$SPACER$RED Could not find openssl on this box to decrypt"
        echo -e "$SPACER$RED Ignoring decryption"
        return 1
      fi
      export pw
      for file in $(find $prefix -name '*.encrypted' ); do
        if ! decrypt_file $file; then
          echo -e "$SPACER$RED-$COLORRESET ERROR: Incorrect password for file $file, Ignoring decryption."
          return 1
        fi
        echo -e "$SPACER$GREEN+$COLORRESET $file"
      done
      ;;
  esac
  return 0
}

##########################################################################################
# main execution

if [ ! -z "$1" ]; then
  prefix=$(absolute_path "$1")
else
  prefix=$PWD
fi

decrypt $prefix
