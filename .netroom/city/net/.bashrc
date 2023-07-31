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

connect() {
  NS=$(command ip netns identify)
  if [ -z "${NS}" ]; then
    # the user is currently in the default ns so they can connect
    CURR=$(basename $(pwd))
    case $CURR in
      router)
        export MACHINE=router
	    ;;
      bank)
        export MACHINE=city1
      ;;
      place)
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
      pasture)
        export MACHINE=village2
      ;;
      station)
        export MACHINE=town1
      ;;
      smith)
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
    unset MACHINE
    printf "Getting ready to "
    command exit > /dev/null
  fi
}

exit() {
  NS=$(command ip netns identify)
  if [ -z "${NS}" ]; then
    # the user is currently in the default ns so they can exit
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
gameover () {
    # create the remains of the princess
    echo "You see a very fancy dress lying on the floor." > dress
    echo "You find the following items littered around the dress:  " >> dress
    echo $(sed "s/HP: .*$//; s/Inventory: //" ~/.stats) >> dress

    curr=`basename $PWD`
    while [ "$curr" != "room" ]; do
        cd .. &> /dev/null
        curr=`basename $PWD`
    done
    MAX_HP=$(awk '/HP:/ { print $4 }' ~/.stats)
    HP=$(awk '/HP:/ { print $2 }' ~/.stats)
    sed "s/HP: .*/HP: $(echo $MAX_HP) \/ $(echo $MAX_HP)/" ~/.stats > ~/.stats.tmp && mv ~/.stats.tmp ~/.stats
    printf "Your butler Man has rushed you back to your rooms.\n"
    COINS=$(awk '/Purse:/ { print $2 }' ~/.stats)
    if [ $COINS -gt 5 ]; then
        let COINS=COINS-5
        printf "You lost 5 coins in the flight\n"
        sed "s/Purse:.*/Purse: $COINS/" ~/.stats > ~/.stats.tmp && mv ~/.stats.tmp ~/.stats
    fi

}
clear
cd ~
cat /net_welcome_message
