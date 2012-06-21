#! /bin/bash

function dryrun () {
    if [ "$DRY_RUN" ]; then
        echo -e "$YELLOW $*"
        return 0
    fi
    eval "$@"
}

# DRY_RUN=1

if [ "$prefix" == "" ]; then
  prefix=$PWD
fi

if  [ $(find $prefix -name '*.symlink' -or -name '*.symlink.private' | wc -l) != 0 ]; then
  echo -e "$GREEN-$COLORRESET found some .symlink files in $prefix, start symlinking"
else
  echo -e "$RED-$COLORRESET found no .symlink files, nothing to do"
  exit
fi


backupall=false
deleteall=false
skipall=false
backupdir=$prefix/backup


for file in $(find $prefix -name '*.symlink' -or -name '*.symlink.private'); do 

    # target is the planned home directory link
    # purefile name is needed in case we work with a prefix
    target="$HOME/.`basename ${file%.symlink*}`"
    purefilename=`basename ${file%.symlink*}`

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

