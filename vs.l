%{
#include "vs.tab.h"
%}
%%
"print"							{return print;}
"return"						{return ret;}
"main"							{return mainToken;}
"Integer"|"String"|"Object"|"Boolean"|"Double"|"void"	{yylval.string = strdup(yytext);return type;}
"true"|"false"						{yylval.string = strdup(yytext);return boolean;}
"=="							{yylval.string = strdup(yytext);return equals;}
"<="|">="|"<"|">"					{yylval.string = strdup(yytext);return comparator;}
"&&"|"||"						{yylval.string = strdup(yytext);return binaryOperand;}
[0-9]+							{yylval.string = strdup(yytext); return integer;}
[0-9]+[.][0-9]+						{yylval.string = strdup(yytext); return real;}
[ \{\}\[\]\(\)\|&!+-=;:,]				{return yytext[0];}
[a-zA-Z]+						{yylval.string = strdup(yytext); return identifier;}
[\n\t]							;
.							{ECHO; yyerror("unexpected character");}
%%
int yywrap(void) {return 1;}

