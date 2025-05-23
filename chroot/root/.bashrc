# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='[e[1;31m]@h[e[0m]:[e[1;34m]w[e[0m]# '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "$(dircolors)"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

# Launch Himorogi tmux session on login if not already running
# Check we are on a virtual console (tty1-6) and not in X or ssh etc.
if [[ -z "$TMUX" ]] && [[ "$(tty)" =~ /dev/tty[0-9]+$ ]]; then
  export TERM=linux
fi

# Custom root prompt
PS1='\u@\h:\w# '
