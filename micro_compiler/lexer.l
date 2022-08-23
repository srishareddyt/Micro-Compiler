%{
#include <string>
#include <vector>
#include "irvect.h"
#include "micro.hpp"
#include <bits/stdc++.h>
using namespace std;
extern int yylex();
%}

%option noyywrap
%option yylineno

%%
PROGRAM {return PROGRAM;}
BEGIN {return _BEGIN;}
IF {return IF;}
ELSE {return ELSE;}
FI {return FI;}
INT {return INT;}
FLOAT {return FLOAT;}
FOR {return FOR;}
ROF {return ROF;}
RETURN {return RETURN;}
END {return END;}
FUNCTION {return FUNCTION;}
READ {return READ;}
WRITE {return WRITE;}
VOID {return VOID;}
STRING {return STRING;}
"+" {return ADD;}
"-" {return SUB;}
"*" {return MUL;}
"/" {return DIV;}
"=" {return EQ;}
"!=" {return NEQ;}
"<" {return LT;}
">" {return GT;}
"<=" {return LTEQ;}
">=" {return GTEQ;}
";" {return SEMI;}
"," {return COMMA;}
":=" {return ASSIGN;}
"(" {return OP;}
")" {return CP;}
[a-zA-Z][a-zA-Z0-9]* {
	yylval.s=new string(yytext);
	return IDENTIFIER;
}
[0-9][0-9]* {
	yylval.s=new string(yytext);
	return INTLITERAL;
}
[0-9]*[.][0-9][0-9]* {
	yylval.s=new string(yytext);
	return FLOATLITERAL;
}
\"([^\\\"]|\\.)*\" {
	yylval.s=new string(yytext);
	return STRINGLITERAL;
}
[-][-].*|.|\n {};
%%
