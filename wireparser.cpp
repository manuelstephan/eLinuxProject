/*************************************************************************
File: wireparser.cpp
Authors: Manuel Stephan and Ben Paras 
Class: ECE497 Embedded Linux
Project: Wireshark Parser 
Version: 2.0

Complete: 
*************************************************************************
- FIFOs working generally under linux in combination with c++ 
- general parsing engine working in basic forward mode
- object oriented approach working
- modified a file and the parser filtered the wrong content
- setupscript in bash provides the FIFOs
- 
Possible Code Improvements: 
*************************************************************************
Use ptrs for more speed if required

To speed it up even more, do a foward mode and a parse mode

Include checking for the reverse magic number!

Information:
*************************************************************************
The pcap-format looks like this: 

typedef struct pcap_hdr_s 
        guint32 magic_number;   * magic number *
        guint16 version_major;  * major version number *
        guint16 version_minor;  * minor version number *
        gint32  thiszone;       * GMT to local correction *
        guint32 sigfigs;        * accuracy of timestamps *
        guint32 snaplen;        * max length of captured packets, in octets *
        guint32 network;        *data link type * 
} pcap_hdr_t;

And this magic number is the thing to look for when implementing a parser! 
*************************************************************************/

/*************************************************************************
Main
*************************************************************************/

#include "wireparser.hpp"

using namespace std;

Parser::Parser()
{
	strcpy(this->buf,"0000");

	this->magic_mask[0] = 0xD4; 			// this is LSB !!! 
	this->magic_mask[1] = 0xC3;
	this->magic_mask[2] = 0xB2;
	this->magic_mask[3] = 0xA1; 			// this is MSB !!
	
	this->magic_number_found = false;    		// when no magic number is found yet..
        this->f_in.open("/tmp/myfifo0",ios::in);	//open file handle, direction in, readingfifo0, 
							//where tcpdump is dropping its data
	this->f_out.open("/tmp/myfifo1",ios::out);	// open file handle, direction out, 
							//writing to fifo1 where wireshark is going to read	
	 	
}


Parser::~Parser()
{
	this->f_in.close();
	this->f_out.close();
}


void Parser::shift()
{
	this->w = this->buf[0];
	for(int i = 0; i < 3; i++)
		this->buf[i] = this->buf[i+1];

	this->buf[3] = this->r; 			// you must read before calling this function!!
}


void Parser::check_for_magic_number()
{
// Checking for the magic_number
if( (buf[0] ==  magic_mask[0]) && (buf[1] ==  magic_mask[1]) && (buf[2] ==  magic_mask[2]) && (buf[3] ==  magic_mask[3]) )
	this-> magic_number_found = true;
else
	;
}

void Parser::read_char()
{
this->f_in.get(this->r);
}

void Parser::write_char()
{
this->f_out << w;
}

void Parser::process_data() // this is kind of a finite state machine processing all the stuff :) 
{

for(int i = 0; i < 4; i++)
	{			//filling the buffer for the first time
	read_char();
	this->buf[i] = this->r;
	}
	
	#ifdef DBG
		cout << "The boss found the magic_number!" << endl; //DBG enabled
	#endif
	while(!f_in.eof())
	{
		// only forward mode ... for testing the named pipe
		// read_char();
		// this->w = this->r;
		// write_char();

		read_char();
		this->check_for_magic_number();
		this->shift();
		
		if(this->magic_number_found)
		{
		write_char();
		}
		else
		{
			;	// do nothing
		}
	
		
	
	}
}



