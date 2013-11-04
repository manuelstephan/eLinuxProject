#include <cstdlib>
#include <iostream>
#include <iomanip>
#include <iostream>
#include <fstream>
#include <string> 
#include <string.h> // for stringlen


class Parser{
 private: 
 char buf[4];
 char r; // the char you currently read from a file ... 
 char w; // the char that is going to be written to a file 
 char magic_mask[4];
 bool magic_number_found;
 std::fstream f_in; 
 std::fstream f_out;

 public:
 Parser();
 ~Parser();
 void shift();
 void read_char();
 void write_char();
 void process_data(); 
 void check_for_magic_number();
 
};

