
[ -s ~/.bashrc ] && source ~/.bashrc

export PS1="\w >"

export GOROOT=/usr/local/go
export GREP_OPTIONS=--color
export RI=-fansi
export RUBYOPT=-rubygems
export EDITOR="emacs --no-init"
export ESHELL=bash
export PAGER=less
export PATH=$PATH:/usr/sbin:/usr/local/sbin:$GOROOT/bin:$HOME/usr/bin:$HOME/.cask/bin
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

    # For Cask
    EMACS=/Applications/Emacs.app/Contents/MacOS/Emacs
fi

export EMACS
export LESS
export JAVA_HOME

[ -f ~/.oldpwd ] && export OLDPWD=$(< ~/.oldpwd)

if which lsof > /dev/null
then
    { lsof -i :8808 || gem server --daemon --port 8808; } > /dev/null 2>&1
fi

