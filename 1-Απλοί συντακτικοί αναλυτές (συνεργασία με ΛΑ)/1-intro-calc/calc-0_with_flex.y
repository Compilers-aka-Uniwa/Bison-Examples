/* 
Onoma arxeiou:	calc-0_with_flex.y
Perigrafh:	Bison arxeio gia syntaktiko elegxo postfix arithitikwn ekfrasewn 
Syggrafeas:	Ergasthrio Metaglwttistwn
 
*/

%{

/* ______________________________________________________________
Orismoi kai dhlwseis glwssas C. Otidhpote exei na kanei me orismo h arxikopoihsh  metablhtwn, arxeia header kai dhlwseis #define mpainei se auto to shmeio 
_______________________________________________________________*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
extern int line;
extern char * yytext;
#define YYSTYPE int
%}

/* ____________________________________________ 
Orismos twn anagnwrisimwn lektikwn monadwn. 
___________________________________________*/

%token INTEGER NEWLINE TOKEN_ERROR

/* _________________________________________
Orismos tou symbolou enarkshs ths grammatikhs 
_____________________________________________*/

%start program

%%

/*____________________________________________
   Orismos twn grammatikwn kanonwn. 
______________________________________________*/
					    
program:
        program expr NEWLINE { printf("%d\n", $2); }
        |
        ;
expr:
        INTEGER          { $$ = atoi(yytext); }
        | expr expr '+' { $$ = $1 + $2; }
        | expr expr '*' { $$ = $1 * $2; }
        ;

%%

/* __________________________________________________

 Epiprosthetos kwdikas-xrhsth se glwssa C pou tha symperilhfthei ston kwdika tou syntaktikoy analyth */


int main(int argc,char **argv)
{
 int i;

 int ret = yyparse();

 if (ret==0)
	printf("\t\tBison -> PARSING SUCCEEDED.\n");
 else
	printf("\t\tBison -> PARSING FAILED.\n");

 return 0;
}
