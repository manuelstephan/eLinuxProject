/*************************************
Main program to instantiate the parser

by Manuel Stephan and Ben Paras
*************************************/
#include "wireparser.hpp"

int main()
{ 
	Parser* p;
	p = new Parser;
	p->process_data();
	delete p;
	return 0;
}
