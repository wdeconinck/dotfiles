# reload this profile
alias reload="source $HOME/.bash_profile"
alias profile="mate $HOME/.bash_profile"

############################################################################
# CONFIG
############################################################################

#rsync with progress and compression
alias rsync="rsync -avz --progress "

# gnuplot shortcut
alias gp=gnuplot

# other alias
alias wifi='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s'
alias path='echo $PATH'
alias lib='echo $DYLD_LIBRARY_PATH'
alias eject="drutil eject"  # or "drutil tray open"

# git alias uses hub instead of git
alias git=hub
source ~/.git-completion.bash
#git enhanced
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWSTASHSTATE=1

# cd shortcuts
alias cd..="cd .."
alias back="cd -"

# Colored output in ls
# ls (see http://www.geekology.co.za/blog/2009/04/enabling-bash-terminal-directory-file-color-highlighting-mac-os-x/)
export CLICOLOR=true
export LSCOLORS=ExBxFxDxcxegedabagacad
alias ls="ls -p"        # show "/" after dirs
alias ll="ls -ghp"      # list view
alias lsort="ls -gShp"  # sorted list view, largest size at top
alias la="ls -Ap"       # show invisibles
alias lr="ll -t | head -5" # show 5 most recent files

# alias to print a bar on screen
alias bar='echo -e "\\033[1;31;40m============================================================\\033[m"'
alias lbar='echo -e "\\033[1;31;40m========================================================================================================================\\033[m"'

# show file and folder sizes
alias duf='du -kd 1 | sort -nr | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done'

# ssh hosts
alias hpacf="ssh hpacf.utias.utoronto.ca"
alias oddjob="ssh oddjob.utias.utoronto.ca"
alias sci="ssh login.scinet.utoronto.ca"
alias lazycat="ssh lazycat.zapto.org"
alias stro014="ssh stro014.vub.ac.be"

# Editor = TextMate
export EDITOR='mate -w'           # waits until file is closed again
export SVN_EDITOR='mate -w'       # same
export GIT_EDITOR='mate -wl1'     # moves cursor to first line
export LESSEDIT='mate -l %lm %f'  # press "v" during less

# grep command
export GREP_OPTIONS="--colour=auto"

# Prompt + title
case $TERM in
xterm* | aterm | rxvt | screen )
XTITLE="\[\e]0;\w\a\]" ;;
* )
XTITLE="" ;;
esac
export PS1="$XTITLE"'\[\e[0;36m\][\[\e[38;3m\]\h \[\e[38;3m\]\A \[\e[32;1m\]\W\[\e[0m\]\[\e[0;36m\]$(__git_ps1 " -- ")\[\e[0m\]\[\e[31;1m\]$(__git_ps1 "%s")\[\e[0m\]\[\e[0;36m\]] \[\e[0m\]'

# bind "set show-all-if-ambiguous on"
bind "set completion-ignore-case on"

############################################################################
# PATH
############################################################################

# Doxygen path
export PATH=/Applications/Doxygen.app/Contents/Resources:$PATH
# user local path
export PATH=/usr/local/bin:$PATH


############################################################################
# FUNCTIONS
############################################################################

# # build & run target
function br  
{ 
    make -j2 $1 && mpirun -np 1 $1 
}
function br2 
{ 
    make -j2 $1 && mpirun -np 2 $1 
}
function ssh-setup
{ 
    cat ~/.ssh/id_rsa.pub | ssh $1 'mkdir -p ~/.ssh; cat - >> ~/.ssh/authorized_keys' 
}

############################################################################
# SOURCES
############################################################################

export PYTHONSTARTUP=~/.pystartup.py

if [ -f ~/.bash_env ]; then
    . ~/.bash_env
fi