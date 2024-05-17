/*  ������ BISON  �� ����� digit.y (����� Flex) ��� ���� ����������� ��� ���������� ����� ��� newline (digit.y). ��� ��������� ���� ������ syntax error.  */

%{
        #include <stdio.h>
        int yylex(void);
        void yyerror(char *);
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
        yyerror("invalid character");
}

void yyerror(char *s) {
        fprintf(stderr, "%s\n", s);
}

int main(void)  {
        yyparse();
        return 0;
}