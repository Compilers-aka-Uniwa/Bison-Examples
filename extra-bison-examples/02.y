%{
	#define YYDEBUG 1
        #include <stdio.h>
        int yylex(void);
        void yyerror(char *);
%}

%token INTEGER NEWLINE
%token PLUS "+"
%token MULT "*"
%token LT "<"
%token GREQ ">="
%token GT ">"

%%


program:
        program expr NEWLINE { printf("\t%d\n", $2); }
        |
        ;
expr:
        INTEGER          { $$ = $1; }
        | expr expr "+"  { $$ = $1 + $2; }
        | expr expr "*"  { $$ = $1 * $2; }
	| expr expr "<"  { printf ("\tIs %d < %d ?\n", $1, $2); if ($1 < $2) $$=1; else $$=0; }
	| expr expr ">=" { printf ("\tIs %d >= %d ?\n", $1, $2); if ($1 >= $2) $$=1; else $$=0; }
	| expr expr ">"	 { printf ("\tIs %d > %d ?\n", $1, $2); if ($1 > $2) $$=1; else $$=0; }
        ;
%%

yylex() {
	char num = 0;
        char c;
        c = getchar();

        // Ignore spaces and tabs
        while (c == ' ' || c == '\t') { yylval = 0; c = getchar(); }

        // Process all digits
        while (c >= '0' && c <= '9')
        {
                yylval = (yylval * 10) + (c - '0');
		num = 1;
		c = getchar();
        }
        if (num) { ungetc(c, stdin); return INTEGER; }

        if (c == '+') return PLUS;
        if (c == '*') return MULT;
	if (c == '<') return LT;
	if (c == '>')
	{
		c = getchar();
		if (c == '=') return GREQ;
		else { ungetc(c, stdin); return GT; }
	}

        if (c == '\n') { yylval = 0; return NEWLINE;}
	if (c == EOF) return 0;
	yyerror("invalid character");
}

void yyerror(char *s) {
        fprintf(stderr, "%s\n", s);
}

int main(void)  {
	yydebug = 0;
        yyparse();
        return 0;
}
