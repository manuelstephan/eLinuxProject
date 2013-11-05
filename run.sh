# Manuel Stephan and Ben Paras
#
# Used to set up the parser and wireshark ... 
# execute as root cause tcpdump requires root rights
#---------------------------------------------------------------
#!/bin/bash
#
# Check if fifos are existant, if not create a pair of them 
#
# todo: pass parameter to the script to specify the interface you want to monitor on the bone 

kill `pidof wireparser` > /dev/null
# kill wireshark not absolutely neccessary
kill `pidof wireshark ` > /dev/null


if [ -f /tmp/myfifo0 ];
then
	mkfifo /tmp/myfifo0   
	echo "mkfifo /tmp/myfifo0 was created ... "
else
   echo "/tmp/myfifo0 already exists ... "
   rm /tmp/myfifo0
   mkfifo /tmp/myfifo0  
fi


if [ -f /tmp/myfifo1 ];
then
	mkfifo /tmp/myfifo1   
	echo "mkfifo /tmp/myfifo1 was created ... "
else
   echo "/tmp/myfifo0 already exists ... "
   rm /tmp/myfifo1
   mkfifo /tmp/myfifo1  
fi
# The fifos are now set up and the other programs can be fired up, if old fifos exist i remove them cause they can contain crap

# Wireparser requires two fifos
echo "Starting wireparser ... "
./wireparser &
echo "Wireparser started successfully ... "


# point this to the bone later ... 
echo "Starting tcpdump ..."
#using your local machine you can do: 
#sudo /usr/sbin/tcpdump -i wlan0 -w- > /tmp/myfifo0 &
# to monitor traffic from the bone use the following command. 
ssh root@192.168.7.2 "/usr/sbin/tcpdump -i eth0 -w- " > /tmp/myfifo0 &
echo "Tcpdump running ..."

echo "Starting wireshark ... " 
/usr/bin/wireshark -k -i /tmp/myfifo1 
echo "Wireshark running ... " 
# now everything should be running and the overview should look like this 
# tcpdump_on_the_bone----->ssh------->myfifo0---->wireparser---->myfifo1----->wireshark

