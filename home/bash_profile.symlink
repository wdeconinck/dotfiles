# reload this profile
alias reload="source $HOME/.bash_profile"
alias profile="edit $HOME/.bash_profile"

############################################################################
# SOURCES
############################################################################

# if [ -f ~/.inputrc ]; then
#     . ~/.inputrc
# fi
# 
if [ -f ~/.bash_extra ]; then
    . ~/.bash_extra
fi

export PYTHONSTARTUP=~/.pystartup.py

############################################################################
# PATH
############################################################################

# Doxygen path
export PATH=/Applications/Doxygen.app/Contents/Resources:$PATH
# user local path
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/share/python:$PATH

############################################################################
# FUNCTIONS
############################################################################

#install homebrew
function install-homebrew
{
     /usr/bin/ruby -e "$(/usr/bin/curl -fksSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"
}

# build & run target
function br  
{ 
    make -j2 $1 && mpirun -np 1 $1 
}
function br2 
{ 
    make -j2 $1 && mpirun -np 2 $1 
}
function bvr  
{ 
    make -j2 $1 && valgrind --leak-check=yes mpirun --dsymutil=yes -np 1 $1
}
function ssh-setup
{ 
    cat ~/.ssh/id_rsa.pub | ssh $1 'mkdir -p ~/.ssh; cat - >> ~/.ssh/authorized_keys' 
}

command_exists () {
    type "$1" &> /dev/null ;
}

# quicklook a document
ql() {
	qlmanage -p "$@" >& /dev/null &
}

function ssh-tunnel-on
{
	ssh -D 8080 -f -C -q -N $1
	networksetup -setsocksfirewallproxy Wi-Fi localhost 8080
	networksetup -setsocksfirewallproxystate Wi-Fi on
}

function ssh-tunnel-off
{
	# kill $SSH_TUNNEL
	networksetup -setsocksfirewallproxystate Wi-Fi off
}

#rsync with progress and compression
alias rsync="rsync -avz --progress "

# gnuplot shortcut
alias gp=gnuplot

# ipython with console, and pylab, good matlab replacement
alias pylab='ipython qtconsole --pylab=inline'

# other alias
alias wifi='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s'
alias path='echo $PATH'
alias lib='echo $DYLD_LIBRARY_PATH'
alias eject="drutil eject"  # or "drutil tray open"
if command_exists mate; then
    alias edit='mate'
else
    alias edit='open -e'
fi
# git alias uses hub instead of git
if command_exists hub ; then
    alias git=hub
fi
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

if [[ "$OSTYPE" =~ ^darwin ]]; then
    alias ls="command ls -pG"
else
    alias ls="command ls --color -p"
fi

# alias ls="command ls -pG"        # show "/" after dirs
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

# Undo a `git push`
alias undopush="git push -f origin HEAD^:master"

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en1"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
alias whois="whois -h whois-servers.net"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Start an HTTP server from a directory
alias server="open http://localhost:8080/ && python -m SimpleHTTPServer 8080"

# Canonical hex dump; some systems have this symlinked
type -t hd > /dev/null || alias hd="hexdump -C"

# OS X has no `md5sum`, so use `md5` as a fallback
type -t md5sum > /dev/null || alias md5sum="md5"

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"

# Shortcuts
alias g="git"
alias m="mate ."

# File size
alias fs="stat -f \"%z bytes\""

# ROT13-encode text. Works for decoding, too! ;)
alias rot13='tr a-zA-Z n-za-mN-ZA-M'

# Empty the Trash
alias emptytrash="rm -rfv ~/.Trash"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.Finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.Finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Disable Spotlight
alias spotoff="sudo mdutil -a -i off"
# Enable Spotlight
alias spoton="sudo mdutil -a -i on"

# PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
alias plistbuddy="/usr/libexec/PlistBuddy"

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do alias "$method"="lwp-request -m '$method'"; done

# Stuff I never really use but cannot delete either because of http://xkcd.com/530/
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 10'"
alias hax="growlnotify -a 'Activity Monitor' 'System error' -m 'WTF R U DOIN'"

# Editor = TextMate
if command_exists mate; then
    export EDITOR='mate -w'           # waits until file is closed again
    export SVN_EDITOR='mate -w'       # same
    export GIT_EDITOR='mate -wl1'     # moves cursor to first line
    export LESSEDIT='mate -l %lm %f'  # press "v" during less
fi

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
