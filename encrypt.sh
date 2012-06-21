#! /bin/bash

if [ "$prefix" == "" ]; then
  prefix=$PWD
fi

if  [ $(find $prefix -name '*.private' | wc -l) != 0 ]; then
  echo -e "$GREEN-$COLORRESET found some private files in $prefix, start locking"
else
  echo -e "$RED-$COLORRESET found no .private files, nothing to do"
  exit
fi

read -p "Encrypt password:" pw
read -p "Verify password: " pw_verif
if [ $pw != $pw_verif ]; then
  echo "Verification failed. Try again."
  exit 1
fi

export pw
for file in $(find $prefix -name '*.private'); do 
  echo "encrypting $file"
  openssl des3 -a -pass "env:pw" -in $file -out `basename $file`.encrypted
done

