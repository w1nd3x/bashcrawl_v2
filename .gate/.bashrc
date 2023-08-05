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
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
HISTIGNORE='cat ~/.bash_history *'
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
    command cd "$@"
}

man() {
  if [[ $# -eq 0 ]]; then
    printf "What manual page do you want?\nFor example, try 'man man'. \n"
    return
  fi
  for i in $(/bin/ls /usr/share/man/catpages)
  do
    if test $i = "$@"; then
      cat "/usr/share/man/catpages/$i" | less
      return
    fi
  done
    printf "No man entry specified for $@\n"
}
apropos() {
  if [[ $# -eq 0 ]]; then
    printf "apropos what?\n" 
    return
  else
    RES=""
    for i in $(/bin/ls /usr/share/man/catpages)
    do
      if awk 'NR==4{gsub(/^ +| +$/,"")}NR==4{printf $0}' /usr/share/man/catpages/$i | grep -o $@  &>/dev/null; then 
        RES="found"
        echo $(awk 'NR==4{gsub(/^ +| +$/,"")}NR==4{printf $0}' /usr/share/man/catpages/$i)
      fi
    done
  fi
  if test -z "$RES" ; then
    echo "Nothing appropriate"
  fi
}
progress() {
  cat ~/.progress

}

exit() {
  head -n -3 ~/.bashrc > ~/.bashrc.tmp
  for i in "$(alias)"; do
    ADDED=$(grep -o "$i" ~/.bashrc)
    if [ -z "$ADDED" ]; then
      echo $i >> ~/.bashrc.tmp
    fi
  done
  echo "clear" >> ~/.bashrc.tmp
  echo "cd \"$(pwd)\"" >> ~/.bashrc.tmp
  echo "echo \"Welcome back!\"" >> ~/.bashrc.tmp
  mv ~/.bashrc.tmp ~/.bashrc
  command exit
}

clear
cd gate
cat /advanced_welcome_message
