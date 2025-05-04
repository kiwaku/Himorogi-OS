# ~/.bash_profile for Himorogi  (root autologin shell)

# Load global profile if present
[ -f /etc/profile ] && . /etc/profile

# Always load personal bashrc, so banner + tmux run
[ -f ~/.bashrc ] && . ~/.bashrc
