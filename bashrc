alias bc='bundle console'
alias be='bundle exec'
alias bi='bundle install'
alias bl='bundle list'

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
alias gs=' git status'
alias gc='git commit' # Never did use `gc`
alias gp='git pull'

type -t pgrep > /dev/null || alias pgrep='ps ax | grep -v grep | egrep'
alias build='make && { make test || make check; }'
alias j=' jobs'
alias ll=' ls -lh'
alias rg='grep -R'

shopt -s cdspell cdable_vars cmdhist extglob histappend no_empty_cmd_completion

for f in ~/.rvm/scripts/rvm ~/perl5/perlbrew/etc/bashrc; do
    [ -f "$f" ] && source $f
done

{ type -t rvm && rvm use default; } > /dev/null 2>&1

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
	echo $message | write $user $tty || return
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
    [ -n "$*" ] && { echo $@ | aspell -a | grep '^&'; } && return 1 || return 0;
}

# ls recent
# usage: lr [DIR]
lr()
{
    ls -lt "$@" | head
}

# usage: newmod [PATTERN]
# `less -F` no good on Dariwn
newmod()
{
    local match=${1:-.}
    mojo get -r metacpan.org/feed/recent 'item > title' text | grep -i "$match" | more -F
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
    local r=$(which rake)
    if [ -f "./.components" ]; then
	bundle exec padrino 'rake' "$@"
    elif [ -f "./Gemfile" -a -f "./Rakefile" ]; then
	bundle exec 'rake' "$@"
    else
	"$r" "$@"
    fi
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
}

# rm empty directories
# usage: rmedir DIR [OPTIONS]
rmedir()
{
   local dir=$1; shift
   [ -n "$dir" ] && find "$dir" -empty -a -type d $* -print0 | xargs -0 rmdir
}
