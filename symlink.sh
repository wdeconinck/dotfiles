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

function dryrun () {
    if [ "$DRY_RUN" ]; then
        echo -e "$YELLOW $*"
        return 0
    fi
    eval "$@"
}

###############################################################################################

function symlink()
{
  if [ ! -z "$1" ]; then
    prefix=$1
  else
    prefix=$PWD
  fi

  if  [ $(find $prefix -name '*.symlink' -or -name '*.symlink.private' -maxdepth 1 | wc -l) != 0 ]; then
    echo -e "$GREEN-$COLORRESET found some .symlink files in $prefix, start symlinking"
  else
    echo -e "$RED-$COLORRESET found no .symlink files in $prefix, nothing to symlink"
    return 0
  fi

  backupall=false
  deleteall=false
  skipall=false
  backupdir=$prefix/backup

  for file in $(find $prefix -name '*.symlink' -or -name '*.symlink.private' -maxdepth 1); do 

    # target is the planned home directory link
    # purefile name is needed in case we work with a prefix
  
    target_base="`basename ${file%.symlink*}`"
    purefilename="`basename ${file%.symlink*}`"
      
    if [[ "$target_base" == *.dotfile* ]]; then
      target_base=".${target_base%.dotfile*}"
      purefilename=${purefilename%.dotfile*}
    fi
  
    target="$HOME/$target_base"
    # if the target is already linked to our .dotfiles directory skip it
    if [ "`readlink $target`" ==  "$file" ]; then
      continue
    fi

    # we have an existing .dotfile
    if [ -e "$target" ]; then
    
      # go down the fast lane if the user has already wished to do something
      # to all files
      if $backupall ; then
        echo -e "$SPACER$YELLOW-$COLORRESET moving $target to backup"
        dryrun mkdir -p $backupdir
        dryrun mv $target $backupdir/
        echo -e "$SPACER$GREEN+$COLORRESET $file $RED->$COLORRESET $target"
        dryrun ln -s $file $target
      elif $deleteall ; then
        echo -e "$SPACER$RED-$COLORRESET deleting existing $target"
        dryrun rm -r $target
        echo -e "$SPACER$GREEN+$COLORRESET $file $RED->$COLORRESET $target"
        dryrun ln -s $file $target
      elif $skipall ; then
        echo -e "$SPACER$YELLOW-$COLORRESET skipping ${file%.*}"
      else
        # no general decision saved, let's ask
        # lower case: decision for the current file
        # upper case: decision for the current and all following file conflicts
        echo "$target exists. What to do? (b)ackup, (d)elete, (s)kip. Or for this and further existing files (B)ackup, (S)kip, (D)elete"
        read filedecision
        case $filedecision in
         b)
           echo -e "$SPACER$YELLOW-$COLORRESET moving $target to $backupdir/.$purefilename"
           dryrun mkdir -p $backupdir
           dryrun mv $target $backupdir/
           echo -e "$SPACER$GREEN+$COLORRESET $file $RED->$COLORRESET $target"
           dryrun ln -s $file $target
           ;;
         B)
           echo backup all
           backupall=true
           echo -e "$SPACER$YELLOW-$COLORRESET moving $target to .dotfiles/backup/.$purefilename"
           dryrun mkdir -p $backupdir
           dryrun mv $target $backupdir/
           echo -e "$SPACER$GREEN+$COLORRESET $file $RED->$COLORRESET $target"
           dryrun ln -s $file $target
           ;;
         d)
           echo -e "$SPACER$RED-$COLORRESET $target"
           dryrun rm -r $target
           echo -e "$SPACER$GREEN+$COLORRESET $file $RED->$COLORRESET $target"
           dryrun ln -s $file $target
           ;;
         D)
           echo deleting all
           deleteall=true
           echo -e "$SPACER$RED-$COLORRESET $target"
           dryrun rm -r $target
           echo -e "$SPACER$GREEN+$COLORRESET $file $RED->$COLORRESET $target"
           dryrun ln -s $file $target
           ;;
         s)
           echo -e "$SPACER$YELLOW-$COLORRESET skipping ${file%.*}"
           continue
           ;;
         S)
           echo skipping all
           skipall=true
           echo -e "$SPACER$YELLOW-$COLORRESET skipping ${file%.*}"
           continue
           ;;
         *)
           echo -e "$RED-$COLORRESET wrong input, skipping"
           continue
           ;;
        esac
      fi
      
    # no existing .dotfile in ~, link found file
    else 
      echo -e "$SPACER$GREEN+$COLORRESET $file $RED->$COLORRESET $target"
      dryrun ln -s $file $target
    fi
  done
  return 0
}

###############################################################################################

function recursive_symlink()
{
  current_dir=$1
  symlink $current_dir
  
  # recurse
  current_dir_base=`basename $current_dir`
  for dir in $(find $current_dir -type d -not -name $(basename $current_dir) -not -name .git -maxdepth 1); do
    recursive_symlink $dir
  done
}

###############################################################################################
# main execution

if [ ! -z "$1" ]; then
  prefix="$PWD/$1"
else
  prefix=$PWD
fi

recursive_symlink $prefix
