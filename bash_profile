
[ -s ~/.bashrc ] && source ~/.bashrc

export PS1="\w >"
export RI=-fansi
export RUBYOPT=rubygems
export EDITOR="emacs --no-init"
export ESHELL=bash
export PAGER=less
export PATH=$PATH:/usr/sbin:/usr/local/sbin:$HOME/usr/bin
export PERLDOC=-MPod::Text::Ansi
# Interpret ANSI codes and don't warn about a bin file
export PERLDOC_PAGER="less -fR"
export GLOBIGNORE=*~:.#*:.git:.svn
export HISTSIZE=5000
export HISTFILESIZE=1000
export HISTCONTROL=ignoreboth

LESS=-FRi
#JAVA_HOME=/usr/java/latest on Fed 10

if [ $(uname -s) == "Darwin" ]
then 
    # On OS X -F quits without displaying 
    LESS=-Ri
    JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home    
fi

export LESS
export JAVA_HOME
