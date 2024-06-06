/* Onoma arxeiou:	calc-0_with_flex.l
   Perigrafh:	Eisodos ergaleiou Flex gia angnorisi akeraiwn kai 
symboloy prosthesis & pol/smou
	
   Syggrafeas:	Ergasthrio Metaglwttistwn, Tmhma Mhx.Plhroforikhs TE, TEI Athhnas

   Sxolia:	O paron kodikas tha dimioyrgisei  (me th xrhsh Flex) mia routina lektikis analysis  pou anagnwrizei: to '+', delimiters (space kai tab), newline,	akeraious sthn aplh morfh [0-9]+ kai lanthasmenous akeraious pou teleiwnoun me kapoio gramma.
*/

%option noyywrap
%x error

/* ________________________________________________________

Kwdikas C gia orismo twn apaitoumenwn header files kai twn metablhtwn. Otidhpote anamesa sta %{ kai %} metaferetai autousio sto arxeio C pou tha dhmiourghsei to Flex. 
__________________________________________________________*/

%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* Header file pou periexei lista me ola ta tokens.
   Prosoxh: Paragetai apo to ergaleio Bison */

#include "calc-0_with_flex.tab.h"

/* _____________________________________________

Orismos metrhth trexousas grammhs 
_________________________________________________*/

int line=1;

void yyerror (const char *msg);
void prn(char *s);

%}

/* _______________________________________________________

Onomata kai antistoixoi orismoi (ypo morfh kanonikhs ekfrashs).
   Meta apo auto, mporei na ginei xrhsh twn onomatwn (aristera) anti twn, synhthws idiaiterws makrsokelwn kai dysnohtwn, kanonikwn ekfrasewn 
____________________________________________________________*/

DELIMITERS	[ \t]+
INTEGER 	[0-9]+

/*___________________________________________________________
 
Gia kathe pattern (aristera) pou tairiazei ekteleitai o antistoixos kwdikas mesa sta agkistra. 
_____________________________________________________________*/

%%
{DELIMITERS}      {}
"+"               {prn("+"); return '+';}
"*"		  {prn("*"); return '*';}
\n                {line++;   return NEWLINE;}
{INTEGER}         {prn("INTCONST"); return INTEGER;}
.                 {yyerror ("Unrecognized token error!"); BEGIN(error); return TOKEN_ERROR;}
<error>.          {}
<error>\n         {BEGIN(0); return NEWLINE; }

%%

/* _______________________________________________________________

H synarthsh typwnei sthn eksodo ena mhnyma lathous sthn periptwsh pou anagnwristei lanthasmeno token opws px. akeraios pou teleiwnei me gramma. ______________________________________________________________*/

void yyerror (const char *msg)
{
    fprintf(yyout, "\tERROR, line %d at lexeme \'%s\' : %s\n",line, yytext, msg);
}

/* ____________________________________________________________

H synarthsh typwnei sthn othonh to keimeno tou anagnwristikou pou tairiakse me kapoion kanona. Xrhsimopoieitai kathara gia logous katanohshs kai debugging. 
______________________________________________________________*/

void prn(char *s)
{
	printf("\tFlex -> Matched token: %s\n", yytext);
}
