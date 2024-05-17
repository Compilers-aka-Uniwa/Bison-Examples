%{
	#define YYDEBUG 1
        #include <stdio.h>
        int yylex(void);
        void yyerror(char *);

	#include <string.h>
        char* sym[] = {"+", "*", ">=", "<", ">"};
        int symlen = sizeof(sym)/sizeof(sym[0]);
        int linenum=0;
%}

%token INTEGER NEWLINE

%%


program:
        program expr NEWLINE { printf("\t[BISON] Line %d is OK!\n", linenum); }
        |
        ;
expr:
        INTEGER          { $$ = $1; }
        | expr expr "+"  { printf("\t[BISON] Result for addition: %d\n", $1+$2); $$ = $1 + $2; }
        | expr expr "*"  { printf("\t[BISON] Result for multiplication: %d\n", $1*$2); $$ = $1 * $2; }
	| expr expr "<"  { printf("\t[BISON] Is %d less than %d ?\n", $1, $2); }
	| expr expr ">=" { printf("\t[BISON] Is %d greater than or equal to %d ?\n", $1, $2); }
	| expr expr ">"	 { printf("\t[BISON] Is %d greater than %d ?\n", $1, $2); }
        ;
%%

yylex() {
	char token_buffer[100];
	strcpy(token_buffer, "");
	int i,j=0;
	int k=0;

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
        if (num)
	{
		ungetc(c, stdin);
		printf("\tInteger '%d' was found!\n", yylval);
		return INTEGER;
	}

	if (c == '\n')
	{
		yylval = 0;
		linenum++;
		return NEWLINE;
	}

        // Check table for matching entry
        for (i=0; i<symlen; i++)
        {
		j=0;
		// Search for specific symbol in symbol table
		sprintf(token_buffer, "%s%c", token_buffer, c);
		while (c == sym[i][j])
		{
			if (j == strlen(sym[i])-1)
			{
				j=-1; break;
			}
			c = getchar();
			sprintf(token_buffer, "%s%c", token_buffer, c);
			j++;
		}
		if (j == 0) strcpy(token_buffer, "");

		// If symbol is found in symbol table then ...
		if (j == -1)
		{
			// ... seek token name in YYNTOKENS internal array
			for (i = 0; i < YYNTOKENS; i++)
			{
				if (yytname[i] && yytname[i][0] == '"'
				    && ! strncmp (yytname[i] + 1, token_buffer, strlen (token_buffer))
				    && yytname[i][strlen (token_buffer) + 1] == '"'
				    && yytname[i][strlen (token_buffer) + 2] == 0) break;
			}
			printf("\tSymbol '%s' was found!\n", token_buffer);
			// If it exists in YYNTOKENS, return actual token value to parser
			if (i < YYNTOKENS) return 255 + i;
			break;
		}
		// If symbol is NOT found, put read character(s) back to standard input
		else
		{
			while (j>=0 && strlen(token_buffer) > 0)
			{
				c=token_buffer[j];
				if (j>0) ungetc(c, stdin);
				j--;
			}
			strcpy(token_buffer, "");
		}
        }

	if (c == EOF)
	{
		printf("\nEnd of file/input!\n");
		return 0;
	}

	printf("\tUnrecognized character '%c'\n", c);
	yyerror("Invalid character!");
}

void yyerror(char *s)
{
        fprintf(stderr, "%s\n", s);
}

int main(void)  {
	yydebug = 0;
        yyparse();
        return 0;
}
