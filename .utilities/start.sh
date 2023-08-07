#!/bin/bash

# set system option to allow a virtual bridge to forward traffic
sudo sysctl -w net.bridge.bridge-nf-call-iptables=0 > /dev/null
sudo sysctl -w net.ipv4.ip_forward=1 > /dev/null

# Create the namespaces
ip netns add router   # namespace for router

# City namespaces
ip netns add city1    # namespace for bank
ip netns add city2    # namespace for something

  # Castle namepsaces
ip netns add castle1      # namespace for Kronk's computer
ip netns add castle2      # namespace for Witch's computer

  # Village namespaces
ip netns add village1    # namespace for farmer
ip netns add village2    # namespace for shepherd

  # Town namespaces
ip netns add town1    # namespace for someone in town
ip netns add town2    # namespace for someone in town

  # Test namespace
ip netns add test
ip netns add test1

# Create virtual ethernet cables
ip link add router0 type veth peer name router0-out
ip link add router1 type veth peer name router1-out
ip link add router2 type veth peer name router2-out
ip link add router3 type veth peer name router3-out
ip link add router4 type veth peer name router4-out

ip link add city10 type veth peer name city10-out
ip link add city20 type veth peer name city20-out

ip link add castle10 type veth peer name castle10-out
ip link add castle20 type veth peer name castle20-out

ip link add village10 type veth peer name village10-out
ip link add village20 type veth peer name village20-out

ip link add town10 type veth peer name town10-out
ip link add town20 type veth peer name town20-out

ip link add test0 type veth peer name test0-out
ip link add test1 type veth peer name test1-out

# Connect the ethernet to a namespace
ip link set router0 netns router
ip link set router1 netns router
ip link set router2 netns router
ip link set router3 netns router
ip link set router4 netns router

ip link set city10 netns city1
ip link set city20 netns city2

ip link set castle10 netns castle1
ip link set castle20 netns castle2

ip link set village10 netns village1
ip link set village20 netns village2

ip link set town10 netns town1
ip link set town20 netns town2

ip link set test0 netns test
ip link set test1 netns test1

# Give the new interfaces bad ip addresses (if we give it to them at all
#router0 ip netns exec router ip addr add 10.0.100.1/24 dev router0
#router1 ip netns exec router ip addr add 10.0.110.1/24 dev router1
#router2 ip netns exec router ip addr add 10.0.120.1/24 dev router2
#router3 ip netns exec router ip addr add 10.0.130.1/24 dev router3
ip netns exec router ip addr add 10.0.140.1/24 dev router4

# Bad IPs for castle
ip netns exec castle1 ip addr add 10.110.0.196/24 dev castle10
ip netns exec castle2 ip addr add 10.169.110.10/24 dev castle20

# Bad IPs for village
ip netns exec village1 ip addr add 120.10.0.128/25 dev village10
ip netns exec village2 ip addr add 111.0.120.10/23 dev village20

# Bad IPs for town
ip netns exec town1 ip addr add 10.10.130.173/24 dev town10
ip netns exec town2 ip addr add 20.20.20.10/24 dev town20

#city1 ip netns exec city1 ip addr add 10.0.100.25/24 dev city10
#city2 ip netns exec city2 ip addr add 10.0.100.36/24 dev city20

#castle1 ip netns exec castle1 ip addr del 10.110.0.196/24 dev castle10
#castle1 ip netns exec castle1 ip addr add 10.0.110.196/24 dev castle10
#castle2 ip netns exec castle1 ip addr del 10.169.110.10/24 dev castle20
#castle2 ip netns exec castle2 ip addr add 10.0.110.169/24 dev castle20

#village1 ip netns exec village1 ip addr del 120.10.0.128/25 dev village10
#village1 ip netns exec village1 ip addr add 10.0.120.128/24 dev village10
#village2 ip netns exec village2 ip addr add 111.0.120.10/23 dev village20
#village2 ip netns exec village2 ip addr add 10.0.120.111/24 dev village20

#town1 ip netns exec town1 ip addr del 10.10.130.173/24 dev town10
#town1 ip netns exec town1 ip addr del 10.130.130.173/24 dev town10
#town1 ip netns exec town1 ip addr del 10.20.130.173/24 dev town10
#town1 ip netns exec town1 ip addr add 10.0.130.173/24 dev town10
#town2 ip netns exec town2 ip addr del 20.20.20.10/24 dev town20
#town2 ip netns exec town2 ip addr add 10.0.130.121/24 dev town20

ip netns exec test ip addr add 10.0.140.42/24 dev test0
ip netns exec test1 ip addr add 10.0.140.84/24 dev test1

# add bridges to work as the network switch for the local networks
ip link add name village-bridge type bridge
ip link add name castle-bridge type bridge
ip link add name town-bridge type bridge
ip link add name city-bridge type bridge
ip link add name test-bridge type bridge

# connect each of the virtual ethernet cables to the switch
ip link set city10-out master city-bridge
ip link set city20-out master city-bridge
ip link set router0-out master city-bridge

ip link set castle10-out master castle-bridge
ip link set castle20-out master castle-bridge
ip link set router1-out master castle-bridge

ip link set village10-out master village-bridge
ip link set village20-out master village-bridge
ip link set router2-out master village-bridge

ip link set town10-out master town-bridge
ip link set town20-out master town-bridge
ip link set router3-out master town-bridge

ip link set test0-out master test-bridge
ip link set test1-out master test-bridge
ip link set router4-out master test-bridge

# turn on all the devices
ip link set dev city-bridge up
ip link set dev castle-bridge up
ip link set dev village-bridge up
ip link set dev town-bridge up
ip link set dev test-bridge up

ip link set dev city10-out up
ip link set dev city20-out up
ip link set dev castle10-out up
ip link set dev castle20-out up
ip link set dev village10-out up
ip link set dev village20-out up
ip link set dev town10-out up
ip link set dev town20-out up
ip link set dev test0-out up
ip link set dev test1-out up
ip link set dev router0-out up
ip link set dev router1-out up
ip link set dev router2-out up
ip link set dev router3-out up
ip link set dev router4-out up

ip netns exec router ip link set dev router0 up
ip netns exec router ip link set dev router1 up
ip netns exec router ip link set dev router2 up
ip netns exec router ip link set dev router3 up
ip netns exec router ip link set dev router4 up
ip netns exec router ip link set dev lo up

ip netns exec city1 ip link set dev city10 up
ip netns exec city1 ip link set dev lo up
ip netns exec city2 ip link set dev city20 up
ip netns exec city2 ip link set dev lo up

ip netns exec castle1 ip link set dev castle10 up
ip netns exec castle1 ip link set dev lo up
ip netns exec castle2 ip link set dev castle20 up
ip netns exec castle2 ip link set dev lo up

ip netns exec village1 ip link set dev village10 up
ip netns exec village1 ip link set dev lo up
ip netns exec village2 ip link set dev village20 up
ip netns exec village2 ip link set dev lo up

ip netns exec town1 ip link set dev town10 up
ip netns exec town1 ip link set dev lo up
ip netns exec town2 ip link set dev town20 up
ip netns exec town2 ip link set dev lo up

ip netns exec test ip link set dev test0 up
ip netns exec test ip link set dev lo up
ip netns exec test1 ip link set dev test1 up
ip netns exec test1 ip link set dev lo up

# Add routes so all connections will work
#city1 ip netns exec city1 ip route add default via 10.0.100.1 dev city10
#city2 ip netns exec city2 ip route add default via 10.0.100.1 dev city20
#
#castle1 ip netns exec castle1 ip route add default via 10.0.110.1 dev castle10
#castle2 ip netns exec castle2 ip route add default via 10.0.110.1 dev castle20
#
#village1 ip netns exec village1 ip route add default via 10.0.120.1 dev village10
#village2 ip netns exec village2 ip route add default via 10.0.120.1 dev village20
#
#town1 ip netns exec town1 ip route add default via 10.0.130.1 dev town10
#town2 ip netns exec town2 ip route add default via 10.0.130.1 dev town20
#

ip netns exec test ip route add default via 10.0.140.1 dev test0
ip netns exec test1 ip route add default via 10.0.140.1 dev test1

# start the python stuff OMG it actually works
ip netns exec castle1 python3 ./.utilities/storefront.py > /dev/null &
ip netns exec castle2 python3 ./.utilities/evil_chat.py > /dev/null &
ip netns exec test1 python3 ./.utilities/farm_listener.py > /dev/null &
ip netns exec test python3 ./.utilities/crime_chat.py > /dev/null &
ip netns exec test1 python3 ./.utilities/cottage_listener.py > /dev/null &
ip netns exec city1 python3 ./.utilities/florian_forwards.py > /dev/null &



