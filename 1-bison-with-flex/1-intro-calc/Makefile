all:
	bison -d calc-0_with_flex.y --verbose
	flex calc-0_with_flex.l
	gcc -o calc-0_with_flex calc-0_with_flex.tab.c lex.yy.c
	./calc-0_with_flex
clean:
	rm calc-0_with_flex.tab.c calc-0_with_flex.tab.h lex.yy.c calc-0_with_flex
