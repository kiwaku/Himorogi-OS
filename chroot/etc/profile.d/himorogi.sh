# /etc/profile.d/himorogi.sh – run banner once per TTY login
if [ -z "$TMUX" ] && [[ "$(tty)" =~ /dev/tty[0-9]+$ ]]; then
  /usr/local/bin/himorogi.sh
fi
