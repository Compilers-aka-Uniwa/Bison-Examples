all:
	bison -d calc-0_with_flex.y
	flex calc-0_with_flex.l
	gcc -o calc-0_with_flex lex.yy.c calc-0_with_flex.tab.c

clean:
	rm calc-0_with_flex.tab.c calc-0_with_flex.tab.h lex.yy.c calc-0_with_flex
