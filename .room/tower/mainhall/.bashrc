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
mv() {
  if ! [[ $# -eq 2 ]]; then
    /bin/mv $@
    return
  fi
  ORIG_PWD=$PWD
  curr=`basename "$PWD"`
  while [ "$curr" != "/" ]; do
    if [ "$curr" = ".Puzzle Room" ]; then
      FROM=$(basename $1)
      TO=$(basename $2)
      if test "$TO" != "$FROM"; then
        printf "\nFor this exercise you need to specify the filename you are moving into, not just the directory\n\n"
        cd "$ORIG_PWD"
        return
      fi
      FROM_PARENT=$(echo $1 | sed "s/$FROM//")
      if test "$FROM_PARENT" != "Left/" && test "$FROM_PARENT" !=  "Right/" && test "$FROM_PARENT" != "Middle/"; then
        printf "\nYou can only move between Left, Right, and Middle in the Puzzle Room\n\n"
        cd "$ORIG_PWD"
        return
      fi
      TO_PARENT=$(echo $2 | sed "s/$TO//")
      if test "$TO_PARENT" != "Left/" && test "$TO_PARENT" !=  "Right/" && test "$TO_PARENT" != "Middle/"; then
        printf "\nYou can only move between Left, Right, and Middle in the Puzzle Room\n\n"
        cd "$ORIG_PWD"
        return
      fi
      # check that FROM is the top of the stack
      FROM_DIR=$(realpath $1 | sed "s/$FROM//")
      for i in $(/bin/ls "$FROM_DIR"); do
        if [[ $FROM -gt $i ]]; then
          printf "\nYou have to move the lowest value from the room before you can pull larger values\n\n"
          cd "$ORIG_PWD"
          return
        fi
      done
      # check that TO is going to be the lowest value
      TO_DIR=$(realpath $2 | sed "s/$TO//")
      for i in $(/bin/ls "$TO_DIR"); do
        if [[ $TO -gt $i ]]; then
          printf "\nYou can't move a larger value onto the top of a smaller value!\n\n"
          cd "$ORIG_PWD"
          return
        fi
      done
      cd "$ORIG_PWD"
      /bin/mv $@
      return
    fi
    cd .. &> /dev/null
    curr=`basename "$PWD"`
  done
  cd "$ORIG_PWD"
  /bin/mv "$@"

}
touch() {
  ORIG_PWD=$PWD
  curr=`basename "$PWD"`
  while [ "$curr" != "/" ]; do
    if [ "$curr" = ".Puzzle Room" ]; then
      printf "\nYou aren't able to use touch inside the puzzle room!!\n\n"
      return
    fi
    cd .. &> /dev/null
    curr=`basename "$PWD"`
  done
  cd "$ORIG_PWD"
  /bin/touch "$@"
}
rm() {
  ORIG_PWD=$PWD
  curr=`basename "$PWD"`
  while [ "$curr" != "/" ]; do
    if [ "$curr" = ".Puzzle Room" ]; then
      printf "\nYou aren't able to use remove inside the puzzle room!!\n\n"
      return
    fi
    cd .. &> /dev/null
    curr=`basename "$PWD"`
  done
  cd "$ORIG_PWD"
  /bin/rm "$@"
}
cp() {
  ORIG_PWD=$PWD
  curr=`basename "$PWD"`
  while [ "$curr" != "/" ]; do
    if [ "$curr" = ".Puzzle Room" ]; then
      printf "\nYou aren't able to use copy inside the puzzle room!!\n\n"
      return
    fi
    cd .. &> /dev/null
    curr=`basename "$PWD"`
  done
  cd "$ORIG_PWD"
  /bin/cp "$@"
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

progress() {
  cat ~/.progress
}
clear
cd room
cat ../welcome_message
