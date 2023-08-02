#!/bin/bash

for i in $(ls ./.utilities/*.py); do 
    PS_ID=$(ps -aux | grep $i | grep -v grep | awk '{ print $2 }')
    if ! [ -z $PS_ID ]; then
        kill -9 $PS_ID > /dev/null
    fi
done

ip netns del city1
ip netns del city2
ip netns del castle1
ip netns del castle2
ip netns del village1
ip netns del village2
ip netns del town1
ip netns del town2
ip netns del test
ip netns del test1
ip netns del router

ip link del name village-bridge type bridge
ip link del name city-bridge type bridge
ip link del name town-bridge type bridge
ip link del name castle-bridge type bridge
ip link del name test-bridge type bridge

sudo sysctl -w net.bridge.bridge-nf-call-iptables=1 > /dev/null
sudo sysctl -w net.ipv4.ip_forward=0 > /dev/null
