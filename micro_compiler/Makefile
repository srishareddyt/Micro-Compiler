dev: 
	@echo "Srisha Reddy Tukkani"
	@echo "190010042@iitdh.ac.in"
compiler:
	@chmod +x runme
	@bison -d -t -o micro.cpp micro.y
	@flex lexer.l
	@g++ -o micro.o -c micro.cpp
	@g++ -c -o lexer.o lex.yy.c
	@g++ -c -o main.o main.cpp
	@g++ -o x.out main.o lexer.o micro.o tabl.cpp scope.cpp syntax.cpp tiny.cpp
clean:
	@rm -f *.o micro.cpp lex.yy.c x.out micro.hpp
