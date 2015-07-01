all:
	gcc lex.yy.c vs.tab.c map.c map_stack.c utils.c -o vs
