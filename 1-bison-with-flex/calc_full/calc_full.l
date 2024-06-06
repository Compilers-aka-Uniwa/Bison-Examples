/*
Flex file for a full calculator
*/

%{
#define YYSTYPE double
#include "calc_full.tab.h"
#include <stdlib.h>
%}

digit 		[0-9]
integer 		{digit}+
exponent 	[eE][+-]?{integer}

%%

[ \t]+                                                   { }
{integer}("."{integer})?{exponent}?      { yylval=atof(yytext); 
 				return NUMBER;
			            }

"+" 	return PLUS;
"-" 	return MINUS;
"*" 	return TIMES;
"/" 	return DIVIDE;
"^"	 return POWER;
"(" 	return LEFT;
")" 	return RIGHT;
"\n" 	return END;
