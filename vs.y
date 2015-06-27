%{
void yyerror (char * s);
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%union {int num; char * string;}
%start file
%token print
%token mainToken
%token <string> type
%token <num> number
%token <string> identifier

%%

file		: ms staticFunctions ms mainFunction ms				{;}
		| ms mainFunction ms						{;}
		;

mainFunction	: mainToken ms '{' lines '}'					{printf("main\n");}
		;

staticFunctions	: staticFunction						{;}
		| staticFunction ms staticFunctions				{;}
		;

staticFunction	: type ms identifier ms argumentsPack ms '{' ms lines ms '}' ms {printf("function with name: %s\n", $3);}
		;

argumentsPack	: '(' ')'							{;}
		| '(' arguments ')'						{;}
		;

arguments	: ms argument ms						{;}
		| ms argument ms ',' ms arguments ms				{;}
		;

argument	: type ' ' ms identifier					{;}
		;

lines		: /* empty */							{;}
		| line								{;}
		| line ms lines							{;}
		;

line		: ';'								{;}
		| assignment ';'						{;}
		| declaration ';'						{;}
		;

assignment	: identifier ms '=' ms number ms				{printf("assigning: %s = %d\n", $1, $5);}
		;

declaration	: type ' ' ms identifier					{printf("declaring: %s %s\n", $1, $4);}

ms		: /* empty */							{;}
		| ' '								{;}
		| ' ' ms							{;}
		;

%%

int main(void) {
	return yyparse();
}

void yyerror (char * s) {
	fprintf(stderr, "%s\n", s);
}
