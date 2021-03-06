#!/usr/bin/env bash
# shellcheck disable=SC2230
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: circa 2006 (forked from .bashrc)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

# ============================================================================ #
#                         G e n e r a l   A l i a s e s
# ============================================================================ #

bash_tools="${bash_tools:-$(dirname "${BASH_SOURCE[0]}")/..}"

# shellcheck disable=SC1090
. "$bash_tools/.bash.d/os_detection.sh"

# shellcheck disable=SC1090
#. "$bash_tools/.bash.d/paths.sh"

# manual local aliases
# shellcheck disable=SC1090
[ -f ~/.aliases ] && . ~/.aliases

# bash_tools defined in .bashrc
# shellcheck disable=SC2154
export bashrc=~/.bashrc
export bashrc2="$bash_tools/.bashrc"
alias r='. $bashrc'
alias rq='set +x; . $bashrc; set -x'
alias bashrc='$EDITOR $bashrc && r'
alias bashrc2='$EDITOR $bashrc2 && r'
alias bashrclocal='$EDITOR $bashrc.local'
alias bashrc3=bashrclocal
alias vimrc='$EDITOR $bash_tools/.vimrc'
alias screenrc='$EDITOR $bash_tools/.screenrc'
alias aliases='$EDITOR $bashd/aliases.sh'
alias ae=aliases
alias be=bashrc
alias be2=bashrc2
alias be3=bashrc3
alias ve=vimrc
alias se=screenrc
# keep emacs with no window, use terminal, not X, otherwise I'd run xemacs...
#alias emacs="emacs -nw"
#em(){ emacs "$@" ; }
#alias em=emacs
#alias e=em
#xe(){ xemacs $@ & }
#alias x=xe

# from DevOps-Perl-tools repo which must be in $PATH
# done via functions.sh now
#alias new=new.pl

# not present on Mac
#type tailf &>/dev/null || alias tailf="tail -f"
alias tailf="tail -f"  # tail -f is better than tailf anyway
alias mv='mv -i'
alias cp='cp -i'
#alias rm='rm -i'
# allows to re-use custommized less behaviour throughout profile without duplicating options
#less='less -RFXig'
#alias less='$less'
export LESS="-RFXig --tabs=4"
# will require LESS="-R"
if type -P pygmentize &>/dev/null; then
    # shellcheck disable=SC2016
    export LESSOPEN='| "$bash_tools/pygmentize.sh" "%s"'
fi
alias l='less'
alias m='more'
alias vi='vim'
alias v='vim'
alias grep='grep --color=auto'
alias envg="env | grep -i"
alias dec="decomment.sh"

alias hosts='sudo $EDITOR /etc/hosts'

alias path="echo \$PATH | tr ':' '\\n' | more"
alias paths=path

alias tmp="cd /tmp"

# not as compatible, better to call pypy explicitly or in #! line
#if type -P pypy &>/dev/null; then
#    alias python=pypy
#fi

# shellcheck disable=SC2139
bt="$(dirname "${BASH_SOURCE[0]}")/.."
export bt
alias bt='sti bt; cd $bt'

# shellcheck disable=SC2154
export bashd="$bash_tools/.bash.d"
alias bashd='sti bashd; cd $bashd'

#alias cleanshell='exec env - bash --rcfile /dev/null'
alias cleanshell='exec env - bash --norc --noprofile'
alias newshell='exec bash'
alias rr='newshell'

alias record=script

alias l33tmode='welcome; retmode=on; echo l33tm0de on'
alias leetmode=l33tmode

alias hist=history
alias clhist='HISTSIZE=0; HISTSIZE=5000'
alias nohist='unset HISTFILE'

export LS_OPTIONS='-F'
if isMac; then
    export CLICOLOR=1 # equiv to using -G switch when calling
else
    export LS_OPTIONS="$LS_OPTIONS --color=auto"
    export PS_OPTIONS="$LS_OPTIONS -L"
fi

alias ls='ls $LS_OPTIONS'
# omit . and .. in listall with -A instead of -a
alias lA='ls -lA $LS_OPTIONS'
alias la='ls -la $LS_OPTIONS'
alias ll='ls -l $LS_OPTIONS'
alias lh='ls -lh $LS_OPTIONS'
alias lr='ls -ltrh $LS_OPTIONS'
alias lR='ls -lRh $LS_OPTIONS'

# shellcheck disable=SC2086
lw(){ ls -lh $LS_OPTIONS "$(type -P "$@")"; }

# shellcheck disable=SC2086,SC2012
lll(){ ls -l $LS_OPTIONS "$(readlink -f "${@:-.}")" | less -R; }

alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
# use bare 'cd' instead, it's more standard
#alias ~='cd ~'

alias screen='screen -T $TERM'
#alias mt=multitail
#alias halt='shutdown -h now -P'
# my pytools github repo
alias ht='headtail.py'

# ============================================================================ #
#                      G i t H u b   /   B i t B u c k e t
# ============================================================================ #

export github=~/github
alias github='cd $github';

export bitbucket=~/bitbucket
# clashes with bitbucket-cli
#alias bitbucket='cd $bitbucket'
alias bitb='cd $bitbucket'
alias bb=bitbucket

if [ -d "$github" ]; then
    for x in "$github/"*; do
        [ -d "$x" ] || continue
        y="${x##*/}"
        y="${y// /}"
        z="${y//-/_}"
        z="${z//./_}"
        z="${z// /}"
        export "$z"="$x"
        # shellcheck disable=SC2139,SC2140
        alias "$y"="sti $y; cd $github/$y"
    done
fi

if [ -d "$bitbucket" ]; then
    for x in "$bitbucket/"*; do
        [ -d "$x" ] || continue
        y=${x##*/}
        z="${y//-/_}"
        z="${z//./_}"
        export "$z"="$x"
        # shellcheck disable=SC2139,SC2140
        alias "$y"="sti $y; cd $bitbucket/$y"
    done
fi

doc_alias(){
    local docpath="$1"
    [ -f "$docpath" ] || return 1
    docfile="${docpath##*/}"
    # slows down shell creation, will drain battery
#    if [ -L "$docpath" ]; then
#        # brew install coreutils to get greadlink since Mac doesn't have readlink -f
#        if type -P greadlink &>/dev/null; then
#            docfile="$(greadlink -f "$docpath")"
#        else
#            docfile="$(readlink -f "$docpath")"
#        fi
#    fi
    #local count=0
    #[ -f ~/docs/$docfile ] && ((count+=1))
    #[ -f "$github/docs/$docfile" ] && ((count+=1))
    #[ -f "$bitbucket/docs/$docfile" ] && ((count+=1))
    #if [ $count -gt 1 ]; then
    #    echo "WARNING: $docfile conflicts with existing alias, duplicate doc '$docfile' among ~/docs, ~/github/docs, ~/bitbucket/docs?"
    #    return
    #fi
    # shellcheck disable=SC2139,SC2140
    alias "d$docfile"="ti ${docpath##*/}; \$EDITOR $docpath"
}

for x in ~/docs/* "$github"/docs/* "$bitbucket"/docs/*; do
    doc_alias "$x" || :
done

# ============================================================================ #

# set in ansible.sh
#alias a='ansible -Db'
alias anonymize='anonymize.py'
alias an='anonymize -a'
alias tf='terraform'
alias bc='bc -l'
alias chromekill='pkill -f "Google Chrome Helper"'
alias eclipse='~/eclipse/Eclipse.app/Contents/MacOS/eclipse';
alias visualvm='~/visualvm/bin/visualvm'

export templates="$github/tools/templates"
alias templates='cd $templates'
alias tmpl=templates

# using brew version on Mac
pmd_opts="-R rulesets/java/quickstart.xml -f text"
if isMac; then
    # yes evaluate $pmd_opts here
    # shellcheck disable=SC2139
    pmd="pmd $pmd_opts"
else
    for x in ~/pmd-bin-*; do
        if [ -f "$x/bin/run.sh" ]; then
            # yes evaluate $x here, and don't export it's lazy evaluated in alias below
            # shellcheck disable=SC2139,SC2034
            pmd="$x/bin/run.sh pmd $pmd_opts"
        fi
    done
fi
alias pmd='$pmd'

# from DevOps Perl tools repo - like uniq but doesn't require pre-sorting keeps the original ordering
alias uniq2=uniq_order_preserved.pl

# for piping from grep
alias uniqfiles="sed 's/:.*//;/^[[:space:]]*$/d' | sort -u"

export etc=~/etc
alias etc='cd $etc'


alias distro='cat /etc/*release /etc/*version 2>/dev/null'
alias trace=traceroute
alias t='$EDITOR ~/tmp'
# causes more problems than it solves on a slow machine missing the prompt
#alias y=yes
alias t2='$EDITOR ~/tmp2'
alias t3='$EDITOR ~/tmp3'
alias tg='traceroute www.google.com'
#alias sec='ps -ef| grep -e arpwatc[h] -e swatc[h] -e scanlog[d]'


# using variable and single alias definition to work around my bash duplicate defs auto checks which would flag the same alias defined twice in two different files, even if only one is sourced depending on the OS
if isMac; then
    clipboard=pbcopy
else
    clipboard=xclip
fi
# shellcheck disable=SC2139
alias clipboard="$clipboard"
alias clip=clipboard
unset -v clipboard


export lab=~/lab
alias lab='cd $lab'

#alias jenkins_cli='java -jar ~/jenkins-cli.jar -s http://jenkins:8080'
alias jenkins-cli='jenkins_cli.sh'
alias backup_jenkins="rsync -av root@jenkins:/jenkins_backup/*.zip '~/jenkins_backup/'"

# Auto-alias uppercase directories in ~ like Desktop and Downloads
#for dir in $(find ~ -maxdepth 1 -name '[A-Z]*' -type d); do [ -d "$dir" ] && alias ${dir##*/}="cd '$dir'"; done

export Downloads=~/Downloads
export Documents=~/Documents
alias Downloads='cd "$Downloads"'
alias Documents='cd "$Documents"'
export down="$Downloads"
export docu="$Documents"
alias down='cd "$Downloads"'
alias docu='cd "$Documents"'
alias doc='cd ~/docs'

export desktop=~/Desktop
export desk="$desktop"
alias desktop='cd "$desktop"'
alias desk=desktop

alias todo='ti T; $EDITOR $HOME/TODO'
alias TODO="todo"
alias don='ti D; $EDITOR $HOME/DONE'
alias DON=don

# drive => Google Drive
export google_drive="$HOME/drive"
export drive="$google_drive"
alias drive='cd "$drive"'

for v in ~/github/pytools/validate_*.py; do
    z="${v##*/}"
    z="${z#validate_}"
    z="${z%.py}"
    # needs to expand now for dynamic alias creation
    # shellcheck disable=SC2139,SC2140
    alias "v$z"="$v"
done

# in some environments I do ldap with Kerberos auth - see ldapsearch.sh script at top level which is more flexible with pre-tuned environment variables
#alias ldapsearch="ldapsearch -xW"
#alias ldapadd="ldapadd -xW"
#alias ldapmodify="ldapmodify -xW"
#alias ldapdelete="ldapdelete -xW"
#alias ldappasswd="ldappasswd -xW"
#alias ldapwhoami="ldapwhoami -xW"
#alias ldapvi="ldapvi -b dc=domain,dc=local -D cn=admin,dc=domain,dc=local"

alias fluxkeys='$EDITOR ~/.fluxbox/keys'
alias fke=fluxkeys
alias fluxmenu='$EDITOR ~/.fluxbox/mymenu'
alias fme=fluxmenu
alias mymenu=fluxmenu
alias menu=mymenu
