TOOLS_CFLAGS	:= -Wstrict-prototypes -Wshadow -Wpointer-arith -Wcast-qual \
		   -Wcast-align -Wwrite-strings -Wnested-externs -Winline \
		   -W -Wundef -Wmissing-prototypes

all:	wireparser

wireparser:  wireparser.o main.o
	g++ -o wireparser wireparser.o main.o

wireparser.o : wireparser.cpp wireparser.hpp
		g++ -c wireparser.cpp

main.o: main.cpp wireparser.hpp
	g++ -c main.cpp

clean:
	rm wireparser.o main.o wireparser
