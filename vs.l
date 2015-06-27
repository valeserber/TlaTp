%{
#include "vs.tab.h"
%}
%%
"print"						{return print;}
"main"						{return mainToken;}
"int"						{yylval.string = strdup(yytext);return type;}
"string"					{yylval.string = strdup(yytext);return type;}
"object"					{yylval.string = strdup(yytext); return type;}
[a-zA-Z]+					{yylval.string = strdup(yytext); return identifier;}
[0-9]+						{yylval.num = atoi(yytext); return number;}
"\n"						;
[ \{\}\[\]\(\)+-=;]				{return yytext[0];}
.						{ECHO; yyerror("unexpected character");}
%%
int yywrap(void) {return 1;}

