# Oh wow, you're very curious!
# This is a bashrc file.
# It runs whenever you open a new terminal
# This one sets some of the options to make the game
# run the way it's supposed to.
# You can edit this in the start file to see what kind
# of changes it can make!
PS1="\$ "
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
cd() {
    [[ $# -eq 0 ]] && return
    builtin cd "$@"
}

man() {
  if [[ $# -eq 0 ]]; then
    /bin/man 
    return
  fi
  for i in $(ls /bin)
  do
    if test $i = "$@"; then
      /bin/man "$@" | less
      return
    fi
  done
        cat << EOF
No man entry specified for $@
EOF
}
apropos() {
  if [[ $# -eq 0 ]]; then
    /bin/apropos 
    return
  else
    RES=""
    for i in $(ls /bin)
    do
      RES=$RES$(whatis $i | grep "$@")
      whatis $i | grep "$@"
    done
  fi
  if test -z "$RES" ; then
    echo "Nothing appropriate"
  fi
}

clear
cd room
cat ../welcome_message
