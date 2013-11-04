/************************************************************************************************
@@Author: Manuel Stephan and Ben Paras 
@@Class: eLinux 
@@Project: Wireshark parser 
@@Version: Basic Object Oriented, working correctly!!! 

Complete: 
*********
- fifos working generally under linux in combination with c++. 
- general parsing engine working in basic forward mode. 
- object oriented approach working.
- modified a file and the parser filtered the wrong content. 

todo: 
*****
use ptrs, setupscript in bash could be cool ... 

do a class as a finfite state machine ... 
with constructors and destructors 

write a destructor !!! 

forward mode 
parse mode 

also check the reverse magic number!

information:
************
The pcap-format looks like this: 

typedef struct pcap_hdr_s 
        guint32 magic_number;   * magic number *
        guint16 version_major;  * major version number *
        guint16 version_minor;  * minor version number *
        gint32  thiszone;       * GMT to local correction *
        guint32 sigfigs;        * accuracy of timestamps *
        guint32 snaplen;        * max length of captured packets, in octets *
        guint32 network;        data link type 
} pcap_hdr_t;

and this magic number is the thing to look for when implementing a parser! 

magic_number: used to detect the file format itself and the byte ordering. The writing application writes 0xa1b2c3d4 with it's native byte ordering format into this field. The reading application will read either 0xa1b2c3d4 (identical) or 0xd4c3b2a1 (swapped). If the reading application reads the swapped 0xd4c3b2a1 value, it knows that all the following fields will have to be swapped too. For nanosecond-resolution files, the writing application writes 0xa1b23c4d, with the two nibbles of the two lower-order bytes swapped, and the reading application will read either 0xa1b23c4d (identical) or 0x4d3cb2a1 (swapped). 

taken from 
http://wiki.wireshark.org/Development/LibpcapFileFormat


*****************************************************************************/

#include <cstdlib>
#include <iostream>
#include <iomanip>
#include <iostream>
#include <fstream>
#include <string> 
#include <string.h> // for stringlen

using namespace std;


#define DBG // getting all the dbg messages ... and switch them off later easily


class Parser{
 private: 
 char buf[4];
 char r; // the char you currently read from a file ... 
 char w; // the char that is going to be written to a file 
 char magic_mask[4];
 bool magic_number_found;
 fstream f_in; 
 fstream f_out;

 public:
 Parser();
 void shift();
 void read_char();
 void write_char();
 void process_data(); 
 void check_for_magic_number();
 
};

// construct the parser 
Parser::Parser()
{
	strcpy(this->buf,"0000");
	this->magic_mask[0] = 0xD4; // this is LSB !!! 
	this->magic_mask[1] = 0xC3;
	this->magic_mask[2] = 0xB2;
	this->magic_mask[3] = 0xA1; // this is MSB !!
	
	this->magic_number_found = false; // when making instance no magic number is found yet..
        this->f_in.open("/tmp/myfifo0", ios::in);// open file handle, direction in, reading fifo0, where tcpdump is dropping its data
	this->f_out.open("/tmp/myfifo1", ios::out);// open file handle, direction out, writing to fifo1 where wireshark is going to read	
	 	
}

void Parser::shift()
{
this->w = this->buf[0];
for(int i = 0; i < 3; i++)
	this->buf[i] = this->buf[i+1];
this->buf[3] = this->r; // you must read before calling this function!!
}


void Parser::check_for_magic_number()
{
// Dr. Logic is back,  checking for the magic_number
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
			;// do nothing
		}
	
		
	
	}
}


int main()
{
Parser p;
p.process_data();
return 0;
}
