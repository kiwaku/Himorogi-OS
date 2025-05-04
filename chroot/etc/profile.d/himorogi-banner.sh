# Show banner once per TTY login
if [[ -z "$BANNER_SHOWN" ]] && [[ "$(tty)" =~ /dev/tty[0-9]+$ ]]; then
  /usr/local/bin/himorogi.sh
  export BANNER_SHOWN=1
fi
