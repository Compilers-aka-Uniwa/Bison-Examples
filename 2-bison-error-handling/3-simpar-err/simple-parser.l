/* Onoma arxeiou:	simple-parser.l
   Perigrafh:		Aplos lektikos analyths - meros tou antistoixou syntaktikou analyth
			(kwdikas gia to ergaleio Flex)
   Syggrafeas:		Ergasthrio Metaglwttistwn, Tmhma Mhx.Plhroforikhs TE, TEI Athhnas
   Sxolia:		To paron programma ylopoiei (me th xrhsh Flex) enan aplo lektiko
			analyth pou anagnwrizei:
				1) Tabs kai kena
				2) Anagnwristika (identifiers - onomata metablhtwn)
				3) Akeraious arithmous
				4) Th leksh "int"
				5) Ton xarakthra ';'
				6) Ton xarakthra '='
				7) Ton eidiko xarakthra '\n' - newline
			Se opoiadhpote allh periptwsh ektypwnei to mhnyma "Token error"
*/

%option noyywrap

/* Kwdikas C gia orismo twn apaitoumenwn header files kai twn metablhtwn.
   Otidhpote anamesa sta %{ kai %} metaferetai autousio sto arxeio C pou
   tha dhmiourghsei to Flex. */

%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* Header file pou periexei lista me ola ta tokens */
#include "simple-parser.tab.h"

extern int flag;
extern int line;

void prn(char *s);

%}

/* Onomata kai antistoixoi orismoi (ypo morfh kanonikhs ekfrashs).
   Meta apo auto, mporei na ginei xrhsh twn onomatwn (aristera) anti twn,
   synhthws idiaiterws makrsokelwn kai dysnohtwn, kanonikwn ekfrasewn */

DELIMITERS [ \t]+
ID [A-Za-z][A-Za-z0-9]*(_[A-Za-z0-9]+)*
DIGIT_H [1-9]
DIGIT_L [0-9]


/* Gia kathe pattern (aristera) pou tairiazei ekteleitai o antistoixos
   kwdikas mesa sta agkistra. H entolh return epitrepei thn epistrofh
   mias sygkekrimenhs arithmhtiks timhs pou antiproswpeuei thn lektikh
   monada pou diabasthke. H timh auth xrhsimopoieitai apo to ergaleio
   Bison gia thn syntaktikh analysh ths eisodou */

%%

"int"				{prn("INT"); return SINT;}
";"				{prn("SEMI"); return SEMI;}
"="				{prn("ASSIGNOP"); return ASSIGNOP;}
{DELIMITERS}			{ }
\n 				{line++; return NL;}
0|-?({DIGIT_H}+{DIGIT_L}*)+	{prn("INTCONST"); return INTCONST;}
{ID} 				{prn("IDENTIFIER"); return IDENTIFIER;}
. 				{printf("\tToken error '%s'\n", yytext);}

%%


/* H synarthsh prn typwnei sthn othonh ton typo tou anagnwristikou (px. ASSIGNOP)
   pou egine match kathws kai to idio to keimeno (px. =) tou anagnwristikou. O
   logos yparkshs ths einai kathara gia kalyterh katanohsh tou kwdika kai gia
   genikoterh dieykolynsh sto debugging ths efarmoghs */

void prn(char *s)
{
	printf("\n\t%s: %s ", s, yytext);
	return;
}
