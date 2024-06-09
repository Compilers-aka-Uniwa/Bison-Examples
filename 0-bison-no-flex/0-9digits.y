/*  αρχείο BISON  με όνομα digit.y (χωρίς Flex) που απλά αναγνωρίζει ένα αριθμητικό ψηφίο και newline (digit.y). Για οτιδήποτε άλλο πετάει syntax error.  */

%{
        #include <stdio.h>
        int yylex(void);
        void yyerror(char *);
        #define YYDEBUG 1
%}

%token DIGIT NEWLINE

%%

program:
        program expr NEWLINE { printf("Digit: %d\n", $2); }
        |
        ;
expr:
        DIGIT          { $$ = $1; }
        ;
%%

yylex() {
        char c;
        c = getchar();

        // Process all digits
        if (c >= '0' && c <= '9')
        {
                yylval = c - '0';
                return DIGIT;
        }
        if (c == '\n') return NEWLINE;
        if (c == EOF) return 0;
        yyerror("invalid character");
}

void yyerror(char *s) {
        fprintf(stderr, "%s\n", s);
}

int main(void)  {
        yydebug = 1;
        yyparse();
        return 0;
}