/* Onoma arxeiou:	simple-parser.y
   Perigrafh:		Aplos syntaktikos analyths (kwdikas gia to ergaleio Bison)
   Syggrafeas:		Ergasthrio Metaglwttistwn, Tmhma Mhx.Plhroforikhs TE, TEI Athhnas
   Sxolia:		O syntaktikos analyths anagnwrizei monaxa:
				1) Dhlwsh metablhths typou integer =========> int a;
				2) Anathesh timhs akeraiou se metablhth ====> a = 5;
				3) Anathesh timhs metablthhs se metablhth ==> a = b;
			Katanoei kai xrhsimopoiei stous grammatikous kanones tis akolouthes
			lektikes monades pou parexontai/anagnwrizontai apo to ergaleio Flex:
				1) SINT		H leksh "int" gia orismo metablhths integer
				2) SEMI		O xarakthras ';' ws termatikos entolhs
				3) ASSIGNOP	O xarakthras '=' gia tis anatheseis timwn
				4) IDENTIFIER	Anagnwristiko / onoma metablhths
				5) INTCONST	Akeraios arithmos
			Anixneuei syntaktika lathh kai typwnei ERROR me arithmo grammhs
*/

%{

/* --------------------------------------------------------------------------------
   Orismoi kai dhlwseis glwssas C. Otidhpote exei na kanei me orismo h arxikopoihsh
   metablhtwn, arxeia header kai dhlwseis #define mpainei se auto to shmeio */

#include <stdio.h>
#include <string.h>
int line=1;
int errflag=0;
extern char *yytext;
#define YYSTYPE char *
int yylex();
int yyerror(char *s);

%}

/* -----------------------------
   Dhlwseis kai orismoi Bison */

/* Orismos twn anagnwrisimwn lektikwn monadwn. */
%token SINT SEMI ASSIGNOP IDENTIFIER INTCONST NL

/* Orismos tou symbolou enarkshs ths grammatikhs */
%start program

%%

/* --------------------------------------------------------------------------------
   Orismos twn grammatikwn kanonwn. Kathe fora pou antistoixizetai enas grammatikos
   kanonas me ta dedomena eisodou, ekteleitai o kwdikas C pou brisketai anamesa sta
   agkistra. H anamenomenh syntaksh einai:
				onoma : kanonas { kwdikas C } */
					    
program	: program decl NL
	| program assign NL
	| program error	NL { printf("\n\t### Line:%d ERROR\n", line-1); errflag=1; }
        |  

decl	: type aid SEMI { printf("\n\t### Line:%d Declaration\n", line); }

type	: SINT 		{ $$ = strdup(yytext); }

aid	: IDENTIFIER	{ $$ = strdup(yytext); }

tim	: INTCONST	{ $$ = "SINT"; }
	| IDENTIFIER	{ $$ = strdup(yytext); }

assign	: aid ASSIGNOP tim SEMI
		{
			if (!strcmp($3, "SINT"))
			{
				printf("\n\t### Line:%d Value assignment\n", line);
			}
			else
			{
				printf("\n\t### Line:%d Variable assignment\n", line);
			}
		}

%%

/* --------------------------------------------------------------------------------
   Epiprosthetos kwdikas-xrhsth se glwssa C. Sto shmeio auto mporoun na prostethoun
   synarthseis C pou tha symperilhfthoun ston kwdika tou syntaktikoy analyth */


/* H synarthsh yyerror xrhsimopoieitai gia thn anafora sfalmatwn. Sygkekrimena kaleitai
   apo thn yyparse otan yparksei kapoio syntaktiko lathos. Sthn parakatw periptwsh h
   synarthsh epi ths ousias den xrhsimopoieitai kai aplws epistrefei amesws. */

int yyerror(char *s)
{}


/* O deikths yyin einai autos pou "deixnei" sto arxeio eisodou. Ean den ginei xrhsh
   tou yyin, tote h eisodos ginetai apokleistika apo to standard input (plhktrologio) */

extern FILE *yyin;


/* H synarthsh main pou apotelei kai to shmeio ekkinhshs tou programmatos.
   Ginetai elegxos twn orismatwn ths grammhs entolwn kai klhsh ths yyparse
   pou pragmatopoiei thn syntaktikh analysh. Sto telos ginetai elegxos gia
   thn epityxh h mh ekbash ths analyshs. */

int main(int argc,char **argv)
{
	int i;
	if(argc == 2)
		yyin=fopen(argv[1],"r");
	else
		yyin=stdin;

	int parse = yyparse();

	if (errflag==0 && parse==0)
		printf("\nINPUT FILE: PARSING SUCCEEDED.\n", parse);
	else
		printf("\nINPUT FILE: PARSING FAILED.\n", parse);

	return 0;
}
