#!/bin/bash


# capture.sh
#

# Manuel Stephan and Ben Paras
#
# Used to monitor traffic on the beagelbone with wireshark 
# execute as root cause tcpdump requires root rights

#---------------------------------------------------------------


#..........begin function definition.........................
# cleaning up at the end of the program

set -e
function cleanup {
  echo "cleaning up .... " 
  rm   /tmp/myfifo0
  rm   /tmp/myfifo1
  ssh root@192.168.7.2 " kill `ssh root@192.168.7.2 "pidof 	  tcpdump"`"
  kill `pidof wireshark`
  # get rid of old fifos
  
}

#...........end function definition...........................


#...........begin program ....................................
# get a trap for the cleanup-function listen on INTerupts ! 
trap cleanup INT 

# check if parameters exists
if [[ -z "$1" ]]; then
	echo "Please specify a proper interface like eth0 or usb0!"
	echo "You do this by ./capture.sh <interfacename>"
	exit
	
elif [ $1 = eth0 ] || [ $1 = usb0 ]; then
	echo "Capturing from $1"
else
	echo "Please specify a proper interface like eth0 or usb0!"
	echo "You do this by ./capture.sh <interfacename>"
	
	exit
fi


# wireshark is required -> check if it is there
if hash wireshark 2>/dev/null; then
        echo "wireshark is installed on your system."
    else
        echo "wireshark is not installed on your system but is prerequisite."
	echo "Try sudo apt-get install wireshark"
        exit 
fi

# The FIFOs are now set up and the other programs can be fired up. If old FIFOs exist, remove them
if [ -e /tmp/myfifo0 ];
then
	rm /tmp/myfifo0
	mkfifo /tmp/myfifo0   
	echo "mkfifo /tmp/myfifo0 was created .. "
else
  
   	mkfifo /tmp/myfifo0  
	echo "mkfifo /tmp/myfifo0 was created ... "
fi


if [ -e /tmp/myfifo1 ];
then
	rm /tmp/myfifo1	
	mkfifo /tmp/myfifo1   
	echo "mkfifo /tmp/myfifo1 was created .. "
else
   	
   	mkfifo /tmp/myfifo1 
	echo "mkfifo /tmp/myfifo1 was created ... " 
fi


# Wireparser requires two FIFOs

echo "Starting tcpdump ..."
#using your local machine you can run: 
#sudo /usr/sbin/tcpdump -i wlan0 -w- > /tmp/myfifo0 &

# to monitor traffic from the bone use the following command. 
ssh root@192.168.7.2 "/usr/sbin/tcpdump -i $1 -w- " > /tmp/myfifo0 &
echo "Tcpdump running ..."

echo "Starting wireshark ... " 
/usr/bin/wireshark -k -i /tmp/myfifo1 & 
echo "Wireshark running ... " 

echo "Starting wireparser ... "
./wireparser 
echo "Wireparser started successfully ... "
# now everything should be running and the overview should look like this 
# tcpdump_on_the_bone----->ssh------->myfifo0---->wireparser---->myfifo1----->wireshark


#...................... end program ............................


