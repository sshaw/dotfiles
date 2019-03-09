
[ -s ~/.bashrc ] && source ~/.bashrc

export PS1="\w >"

export DISABLE_SPRING=1
export GOPATH=$HOME/.go
export GREP_OPTIONS=--color
export RI=-fansi
export EDITOR="emacs --no-init"
export ESHELL=bash
export PAGER=less
export PATH=$PATH:$HOME/.rvm/bin:$HOME/bin:$HOME/usr/bin:/usr/sbin:/usr/local/sbin:$GOPATH/bin:$HOME/.cask/bin:$HOME/.jenv/bin
export PERLDOC=-MPod::Text::Ansi
# Interpret ANSI codes and don't warn about a bin file
export PERLDOC_PAGER="less -fR"
export GLOBIGNORE=*~:.#*:.git:.svn
export HISTSIZE=5000
export HISTFILESIZE=1000
export HISTCONTROL=ignoreboth
export IGNOREEOF=default
export IRB_HISTCONTROL=ignoreboth
export IRB_HISTIGNORE='q!:^\s*r!\b'
export NVM_DIR=$HOME/.nvm

LESS=-FRi
#JAVA_HOME=/usr/java/latest on Fed 10

if [ $(uname -s) == "Darwin" ]
then
    # On OS X -F quits without displaying
    LESS=-Ri
    JAVA_HOME=`/usr/libexec/java_home`

    # For Cask
    export EMACS=/Applications/Emacs.app/Contents/MacOS/Emacs
fi

export LESS
export JAVA_HOME

[ -f ~/.oldpwd ] && export OLDPWD=$(< ~/.oldpwd)

# Export environment variables containing scratch files
# $SCRPL = $TMPDIR/scratch.pl
for ext in c go json js pl py rb sql xml yml; do
    eval "export SCR$(echo $ext | tr a-z A-Z)=${TMPDIR}scratch.$ext"
done

# if which lsof > /dev/null
# then
#     { lsof -i :8808 || gem server --daemon --port 8808; } > /dev/null 2>&1
# fi
