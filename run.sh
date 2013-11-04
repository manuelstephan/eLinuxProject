# Manuel Stephan and Ben Paras
#
# Used to set up the parser and wireshark ... 
#
#---------------------------------------------------------------
#!/bin/bash
#
# Check if fifos are existant, if not create a pair of them 
if [ -f /tmp/myfifo0 ];
then
	mkfifo /tmp/myfifo0   
	echo "mkfifo /tmp/myfifo0 was created ... "
else
   echo "/tmp/myfifo0 already exists ... "
fi


if [ -f /tmp/myfifo1 ];
then
	mkfifo /tmp/myfifo1   
	echo "mkfifo /tmp/myfifo1 was created ... "
else
   echo "/tmp/myfifo0 already exists ... "
fi

# The fifos are now set up and the other programs can be fired up ... 
# Wireparser requires two fifos
echo "Starting wireparser ... "
./wireparser &
echo "Wireparser started successfully ... "


# point this to the bone later ... 
echo "Starting tcpdump ..."
sudo /usr/sbin/tcpdump -i wlan0 -w- > /tmp/myfifo0 &
echo "Tcpdump running ..."

echo "Starting wireshark ... " 
/usr/bin/wireshark -k -i /tmp/myfifo1 & 
echo "Wireshark running ... " 
# now everything should be running and the overview should look like this 
# tcpdump_on_the_bone----->ssh------->myfifo0---->wireparser---->myfifo1----->wireshark

