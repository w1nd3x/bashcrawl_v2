#!/bin/bash

ip netns del city1
ip netns del city2
ip netns del castle1
ip netns del castle2
ip netns del village1
ip netns del village2
ip netns del town1
ip netns del town2
ip netns del test
ip netns del router

ip link del name village-bridge type bridge
ip link del name city-bridge type bridge
ip link del name town-bridge type bridge
ip link del name castle-bridge type bridge
ip link del name test-bridge type bridge

sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sysctl -w net.ipv4.ip_forward=0
