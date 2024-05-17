all:
	bison -d simple-parser.y
	flex simple-parser.l
	gcc simple-parser.tab.c lex.yy.c -o simple-parser

clean:
	rm simple-parser.tab.c simple-parser.tab.h lex.yy.c simple-parser
