
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
export IRB_HISTIGNORE='q!:^\s*r!'
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
for ext in c el go groovy java json js pl py rb sh sql ts txt xml yml yaml; do
    eval "export SCR$(echo $ext | tr a-z A-Z)=${TMPDIR}scratch.$ext"
done
unset ext

root="$(brew --prefix asdf 2>/dev/null)"
if [ -d "$root" ]; then
    . "$root/asdf.sh"
    . "$root/etc/bash_completion.d/asdf.bash"
elif [ -d "$HOME/.asdf" ]; then
    . "$HOME/.asdf/asdf.sh"
    . "$HOME/.asdf/completions/asdf.bash"
fi
unset root
