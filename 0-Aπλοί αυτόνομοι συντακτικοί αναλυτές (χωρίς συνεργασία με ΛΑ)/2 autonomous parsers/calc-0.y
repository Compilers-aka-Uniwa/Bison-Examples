/*  αρχείο BISON  με όνομα calc-0.y (χωρίς flex) για απλές αριθμητικές πράξεις, άθροισμα και πολ/σμο με postfix notation (πχ. 5 4 +)  */

%{
        #include <stdio.h>
        int yylex(void);
        void yyerror(char *);
%}

%token INTEGER PLUS MULT NEWLINE

%%

program:
        program expr NEWLINE { printf("%d\n", $2); }
        |
        ;
expr:
        INTEGER          { $$ = $1; }
        | expr expr PLUS { $$ = $1 + $2; }
        | expr expr MULT { $$ = $1 * $2; }
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
        if (c == '\n') { yylval = 0; return NEWLINE;}
        yyerror("invalid character");
}

void yyerror(char *s) {
        fprintf(stderr, "%s\n", s);
}

int main(void)  {
        yyparse();
        return 0;
}

