alias bc='bundle console'
alias be='bundle exec'
alias bi='bundle install'
alias bl='bundle list'
alias bo='bundle open'

# Mojolicious
alias mapp='./script/*'
alias mr='mapp routes'
alias mt='mapp test'
alias md='mapp daemon'
###

alias pbuild='perl Makefile.PL && make && make test'
alias pinstall='pbuild && make install'
alias pb='perlbrew'
alias pd='perldoc'

alias fxml='xmllint --format'
alias vxsd='xmllint --noout --schema'
alias vrng='xmllint --noout --relaxng' # Trang is much better for this...

alias gd=' git diff'
alias gs=' git status -sb'
alias gf=' git fetch'
alias gl=' git hist'
alias gc='git commit' # Never did use `gc`
alias gp='git pull'

alias rc='rails c'
alias pc='padrino c'

alias dm=docker-machine
alias dmrun='docker-machine start default && eval "$(docker-machine env default)"'

which hub &> /dev/null && alias 'git=hub'

type -t pgrep > /dev/null || alias pgrep='ps ax | grep -v grep | egrep'

alias build='make && { make test || make check; }'
alias j=' jobs'
alias q=' exit'

alias ls=' ls -FG'
# BSD vs GNU
ls --color &> /dev/null && alias ls=' ls -F --color=auto'

alias ll=' ls -lh'
alias rg='egrep -R'

alias sctl=systemctl
alias myip='dig @resolver1.opendns.com myip.opendns.com +short'

alias uri_escape='perl -MURI::Escape -E"say uri_escape(@ARGV ? shift : (\$_=<>) && chomp && \$_)"'
alias uri_unescape='perl -MURI::Escape -E"say uri_unescape(@ARGV ? shift : (\$_=<>) && chomp && \$_)"'

shopt -s cdspell cdable_vars cmdhist extglob histappend no_empty_cmd_completion

# export some cdable_vars
for f in ~/code/*; do
    [ -d "$f" ] && export $(basename "$f")="$f"
done

for f in \
    ~/.rvm/scripts/rvm \
    ~/perl5/perlbrew/etc/bashrc \
    ~/.gvm/bin/gvm-init.sh; do
    # /usr/local/share/chruby/chruby.sh \
    # /usr/local/share/chruby/auto.sh; do

    [ -f "$f" ] && source $f
done

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
{ type -t rvm && rvm use default; } > /dev/null 2>&1

for cmd in cap rails rspec padrino; do
  eval "
    $cmd() {
      local exe=\$(which $cmd)
      if [ -x "./bin/$cmd" ]; then
        ./bin/$cmd \"\$@\"
      elif [ -f "./Gemfile" ]; then
        bundle exec $cmd \"\$@\"
      else
        command $cmd \"\$@\"
      fi
    }
"
done

# `write` to a user on all of their TTYs
# usage: annoy USER MESSAGE
annoy()
{
    if [ $# -lt 2 ]; then
        echo usage: $FUNCNAME USER MESSAGE
        return 1
    fi

    local user=$1; shift
    local message=$*
    local ttys=$(who | perl -lane"print \$F[1] if /\b$user\b/")

    if [ -z "$ttys" ]; then
        echo $user is not logged in
        return 2
    fi

    for tty in $ttys; do
        [ "$tty" == ":0" -o "$tty" == "console" ] && continue     # Skip the console
        echo "$message" | write $user $tty || return
    done
}

# Average file size
# usage: avgsz [DIR]
avgsz()
{
    find "${1:-.}" -type f | perl -lne'$sz += -s $_; END { printf "%.2fKB\n", $sz/($.||1)/2**10 }'
}

# usage: bigfile [GB] | [FILE [GB]]
bigfile()
{
    local file
    local size=1 # 1GB

    if [[ $1 =~ ^[0-9]+$ ]]; then
      size=$1
      shift
    fi

   file=${1:-bigfile}
   size=${2:-$size}

   dd if=/dev/zero of="$file" bs=1k count=$((1024*1024*$size))
}

# Can't spell <:^(
# usage: canspell WORD
# $* instead of $@
canspell()
{
    [ -n "$*" ] && { echo "$@" | aspell -a | grep '^&'; } && return 1 || return 0;
}

_error()
{
    echo "$*" >&2
}

# Node shell
nsh()
{
    local init="" path="$(npm config get prefix)/lib/node_modules"
    [ -f ~/.noderc ] && init=$(< ~/.noderc)
    [ -f ./.noderc ] && init="$init"$'\n'$(< ./.noderc)

    NODE_NO_READLINE=1 NODE_PATH="$path" rlwrap node -i -e "$init"
}

# Output gitignore files
# usage: gi list | lang[,lang...]
gi()
{
    wget -O- -q https://www.gitignore.io/api/$1
}

# GitHub grep
# usage: gh-grep [OPTIONS] pattern
gh_grep()
{
    local github="https://github.com"
    local remote="origin"

    local branch=$(git symbolic-ref HEAD 2>/dev/null)
    [ -z "$branch" ] && { _error "Detached head"; return 1; }

    branch=${branch##*/}

    local dir=$(git config --get "remote.$remote.url")
    [ -z "$dir" ] && { _error "No remote named $remote"; return 1; }

    # account for https://... and git@...
    dir=${dir#$github/}
    dir=${dir##*:}
    dir=${dir%.*}

    git grep -n --full-name "$@" | perl -aF'([-:])' -ne"
      BEGIN{\$\"=undef}
      print /^--$/ ? \$_ : qq{$github/$dir/tree/$branch/\$F[0]#L\$F[2]@F[3..\$#F]}
    "
}

# ls recent
# usage: lr [-N] [OPTIONS] [DIR]
lr()
{
    local n

    if [[ $1 =~ ^-[0-9]+$ ]]
    then
      n=$1
      shift
    fi

    # Force color and skip ls summary
    # BSD; note GNU ls will need --color=force
    CLICOLOR_FORCE=1 ls -lt "$@" | perl -ne'print unless $.==1' | head $n
}

# usage: newmod [PATTERN]
# `less -F` no good on Dariwn
newmod()
{
    local match=${1:-.}
    mojo get -r metacpan.org/feed/recent 'item > title' text | egrep -i "$match" | more -F
}

# Perl Module Exports
# usage: pme MODULE
pme()
{
    [ -n "$1" ] && perl -M$1 -le"print for sort @$1::EXPORT"
}

# Perl Module's Version
# usage: pmv [M1, [M2, ...]]
pmv()
{
    #From http://www.perlmonks.org/?node_id=37237
    perl -e'foreach my $module ( @ARGV ) {
      eval "require $module";
      printf( "%-20s: %s\n", $module, $module->VERSION ) unless ( $@ );
    }' $@
}

# Poor man's perl shell
psh()
{
    perl -MData::Dump=dd -wne'BEGIN { $p = "perl > "; print $p }; dd eval; print $p'
}

rake()
{
    if [ -x ./bin/rake ]; then
	./bin/rake "$@"
    elif [ -f "./.components" ]; then
	# TODO: I think padrono dropped this
        bundle exec padrino 'rake' "$@"
    elif [ -f "./Gemfile" -a -f "./Rakefile" ]; then
        bundle exec 'rake' "$@"
    else
        command rake "$@"
    fi
}

# Handy when you need to paste & process:
# > tmp
# > xmllint --format $(tmp)
# > perl -nE'do_something($_)' $(tmp)
tmp() {
    local path=/tmp/$RANDOM.tmp
    cat > $path
    tmp=$path
    echo $path
}

# Use RDoc server over `ri`
ri()
{
    if [ -z "$1" ]; then
        command ri
        return
    fi

    # TODO: try to use whatever browser is currently open
    url="http://localhost:8808/rdoc?q=$*"
    if [ $(uname -s) == "Darwin" ]; then
        open -a Opera "$url"
    else
        opera "$url" &
    fi

    # Fallback if command failed
    [ $? -ne 0 ] && command ri "$@"
}

# rm empty directories
# usage: rmedir DIR [OPTIONS]
rmedir()
{
   local dir=$1; shift
   [ -n "$dir" ] && find "$dir" -empty -a -type d $* -print0 | xargs -0 rmdir
}
