@@ Author: Manuel Stephan, Ben Paras
@@ 
====================================
Function description: 
---------------------

Files contained: 
----------------
README.md			: This file. 
original.pcap			: Contains a original tcpdump capture without any additional information. It can be used to test the general setup of the named pipes. 
confused.pcap			: This file was confused with additional characters to verify the functionality of the parser. 
run.sh				: Sets up the environment and runs the programs required.
wireparser.cpp			: C++ Source of the wireparser. 


Build information
-----------------
The wireparser is the only program that has to be built. 
Just type make to build it. 
