#! /bin/bash


if [ "$prefix" == "" ]; then
  prefix=$PWD
fi

if  [ $(find $prefix -name *.encrypted | wc -l) != 0 ]; then
  echo -e "$GREEN-$COLORRESET found some locked files in $prefix, start decrypting"
else
  echo -e "$RED-$COLORRESET found no .encrypted files, nothing to do"
  exit 0
fi

function command_exists() 
{ 
  type "$1" &> /dev/null
}

if ! command_exists openssl; then 
  echo -e "$RED Could not find openssl on this box to decrypt"
  exit 
fi

read -p "password: " pw
export pw
for file in $(find $prefix -name *.encrypted); do 
  echo "decrypting $file"
  openssl des3 -a -d -pass "env:pw" -in $file -out `basename ${file%.encrypted}`
done
