# Oh wow, you're very curious!
# This is a bashrc file.
# It runs whenever you open a new terminal
# This one sets some of the options to make the game
# run the way it's supposed to.
# You can edit this in the start file to see what kind
# of changes it can make!
PS1="\$ "
#shopt -s histappend
HISTCONTROL=ignoreboth
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
HISTIGNORE='cat ~/.bash_history *'
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
    command cd "$@"
}

ip() {
  NS=$(command ip netns identify)
	if [ -z "${NS}" ]; then
		printf "You have to connect to a computer before you can use ip\n"
		return
	else
		command ip "$@"
	fi
  
}

ss() {
  NS=$(command ip netns identify)
	if [ -z "${NS}" ]; then
		printf "You have to connect to a computer before you can use ss\n"
		return
	else
		command ss "$@"
	fi
}

nc() {
  NS=$(command ip netns identify)
	if [ -z "${NS}" ]; then
		printf "You have to connect to a computer before you can use nc\n"
		return
	else
		command nc "$@"
	fi 
}

ping() {
  NS=$(command ip netns identify)
	if [ -z "${NS}" ]; then
		printf "You have to connect to a computer before you can use ping\n"
		return
	else
		command ping "$@"
	fi 
}

connect() {
  NS=$(command ip netns identify)
  if [ -z "${NS}" ]; then
    # the user is currently in the default ns so they can connect
    CURR="$(basename "$(pwd)")"
    case $CURR in
      router)
        export MACHINE=router
	    ;;
      "Big Bank")
        export MACHINE=city1
      ;;
      "Factory Donut")
        export MACHINE=city2
      ;;
      Workshop)
        export MACHINE=castle1
	    ;;
      "Secret Tower")
        export MACHINE=castle2
      ;;
      farm)
        export MACHINE=village1
      ;;
      cottage)
        export MACHINE=village2
      ;;
      "Police Station")
        export MACHINE=town1
      ;;
      "No Bucks")
        export MACHINE=town2
      ;;
      *)
        printf "There is no machine to connect to here!\n\n"
	      return
        ;;
    esac
    # save off the bash file
    cp ~/.bashrc ~/.bashrc.bak
    head -n -3 ~/.bashrc > ~/.bashrc.tmp
    mv ~/.bashrc.tmp ~/.bashrc
    # save off bash history
    cp ~/.bash_history ~/.bash_history.bak
    cat /dev/null > ~/.bash_history
    sed -e '/PS1=.*/{s//PS1=\"user@\$MACHINE\\\$ \"/;:a' -e '$!N;$!ba' -e '}' ~/.bashrc > ~/.bashrc.tmp && cp ~/.bashrc.tmp ~/.bashrc
    command ip netns exec $MACHINE bash
    printf "Returned from $MACHINE\n\n"
  else
    # the user is not in the default namespace so they must disconnect first
    printf "You must disconnect from the current machine before you can connect to a new one!\n\n"
    return
  fi
}

disconnect() {
  NS=$(command ip netns identify)
  if [ -z "${NS}" ]; then
    # the user is currently in the default ns so they cannot disconnect
    printf "You must connect to a machine before you can disconnect!\n\n"
    return 
  else
    # the user is not in the default namespace so they can disconnect 
    mv ~/.bashrc.bak ~/.bashrc
    mv ~/.bash_history.bak ~/.bash_history
    unset MACHINE
    printf "Getting ready to "
    command exit > /dev/null
  fi
}

exit() {
  NS=$(command ip netns identify)
  if [ -z "${NS}" ]; then
    # the user is currently in the default ns so they can exit
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
  else
    # the user is not in the default namespace so they must disconnect first
    printf "You must disconnect from the current machine before you can exit the game!\n\n"
    return
  fi
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
clear
cd ~
cat /net_welcome_message
