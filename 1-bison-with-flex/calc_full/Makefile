all:
	bison -d calc_full.y
	flex calc_full.l
	gcc -o calc_full lex.yy.c calc_full.tab.c -lfl -lm
	./calc_full
clean:
	rm calc_full lex.yy.c calc_full.tab.c calc_full.tab.h
