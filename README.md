


ECE497 Fall 2013 Project 
========================

Authors: Manuel Stephan and Ben Paras

Description:
----------------------------
This repository contains all the necessary files in the project needed to monitor traffic on the beagle using tcpdump + wireshark. 

See this link for setup,configuration, and user instructions: http://www.elinux.org/ECE497_Project_WireShark


Files contained: 
---------------- 
  README.md			    : This file
  
  original.pcap			: Original tcpdump capture in pcap format used to test general set up of named pipes 
  
  confused.pcap			: A altered captured file that has extra characters and is used  to show that wireparser works 
 
  capture.sh				: Sets up the environment and runs the programs required 
 
  wireparser.cpp		: C++ Source of the wireparser 
    
  wireparser.hpp		: C++ header file for wireparser 
  
  main.cpp          : Creates an instance of the wireparser and runs it
  
  Makefile          : Makefile for wireparser 
  
  


Build information
-----------------
The wireparser is the only program that has to be built. 
Just type 'make' to build it. 
