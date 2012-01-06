
[ -s ~/.bashrc ] && source ~/.bashrc

export RI=-fansi
# -F and -u dont work on OS X..?
export LESS=-FRi
export RUBYOPT=rubygems
export EDITOR=emacs
export ESHELL=bash
export PATH=$PATH:/usr/sbin:$MAGICK_HOME/bin:$HOME/usr/bin
export PERLDOC=-MPod::Text::Ansi
# Interpret ANSI codes and don't warn about a bin file
export PERLDOC_PAGER="less -fR"
export FIGNORE=.svn:.git
# erasedups needs >= 3
export HISTCONTROL=ignoreboth:erasedups


