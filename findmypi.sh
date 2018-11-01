#!/bin/sh
#
# findmypi.sh
# 
# look to see if wifi is connected
# if no wifi, create an access point so that a new wifi
# connection can be established.
#
# the idea is that this eases moving a raspberry pi to a new location
# and then needing to plug in a wire to connect to available wifi.
#
# open questions:
# could nmcli be used to determine network status more intelligently?
# would it be better to scan for known networks before opening access point?
#
# Peter F. Klemperer
# November 1, 2018


# test if wifi is connected
WifiConnected=$(cat /sys/class/net/wlan0/carrier)
if ! [ $WifiConnected ]
then 
	echo "Not Online" > /dev/stderr
fi


# test if internet is reachable
PUBLIC_SITE=google.com
INTERNETPINGTIME=$(ping -q -w1 -c1 $PUBLIC_SITE 2> /dev/null | grep "1 received")
if [ "$INTERNETPINGTIME" = "" ]
then
	PublicConnected=0
	echo "cannot reach public internet"
fi

# test if private network is reachable
MY_PRIVATE_NETWORK=multibots.cs.mtholyoke.edu
PINGTIME=$(ping -q -w1 $MY_PRIVATE_NETWORK 2> /dev/null | grep "1 received")
if [ "$PINGTIME" = "" ]
then
	PrivateConnected=0
	echo "cannot reach private network"
fi

# in the event that pi is not connected to wifi,
# set up a local access point
if ! [ $WifiConnected ]
then
	SSID=$(hostname)-hotspot
	password=robotsarecool
	echo "Opening Access Point"
	nmcli device wifi hotspot con-name my-hotspot ssid $SSID band bg password $PASSWORD 
fi


