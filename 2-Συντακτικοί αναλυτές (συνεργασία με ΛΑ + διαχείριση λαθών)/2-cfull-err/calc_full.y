/* 
A calculator that understands +, -, *, /, and ^ (power) and gives them the correct precedence, understanding brackets. 
Error handling using error pseudo-token.
*/

%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE double

int yyerror(char *s);
int yylex();

%}

%token NUMBER
%token PLUS MINUS TIMES DIVIDE POWER
%token LEFT RIGHT
%token END

%left PLUS MINUS
%left TIMES DIVIDE
%left NEG
%right POWER

%start Input
%%

Input:
    
     | Input Line
;

Line:
     END
     | Expression END { printf("Result: %f\n", $1); }
     | error END { printf("\tERROR!!!\n"); }
;

Expression:
     NUMBER { $$=$1; }
| Expression PLUS Expression { $$=$1+$3; }
| Expression MINUS Expression { $$=$1-$3; }
| Expression TIMES Expression { $$=$1*$3; }
| Expression DIVIDE Expression { $$=$1/$3; }
| MINUS Expression %prec NEG { $$=-$2; }
| Expression POWER Expression { $$=pow($1,$3); }
| LEFT Expression RIGHT { $$=$2; }
;

%%

int yyerror(char *s) {
  printf("\t%s\n", s);
}

int main() {
  if (yyparse()==0)
     fprintf(stderr, "Successful parsing.\n");
  else
     fprintf(stderr, "error found.\n");
}
