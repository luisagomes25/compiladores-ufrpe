exemplo: exemplo.y exemplo.l
	bison -d exemplo.y
	flex exemplo.l
	gcc exemplo.tab.c lex.yy.c -o exemplo 

clean:
	rm -f exemplo exemplo.tab.c exemplo.tab.h lex.yy.c
