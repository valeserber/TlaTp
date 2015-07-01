%{
#include "vs.tab.h"
%}
%%
"print"							{return print;}
"return"						{return ret;}
"function"						{return function;}
"main"							{return mainToken;}
"if"							{return ifToken;}
"else"							{return elseToken;}
"while"							{return whileToken;}
"Integer"|"String"|"Object"|"Boolean"|"Double"|"void"	{yylval.string = strdup(yytext);return type;}
"true"|"false"						{yylval.string = strdup(yytext);return boolean;}
"<="|">="|"<"|">"|"=="			{yylval.string = strdup(yytext);return comparator;}
"&&"|"||"						{yylval.string = strdup(yytext);return booleanBinaryOperand;}
"+"|"-"|"*"|"%"|"/"|"^"					{yylval.string = strdup(yytext);return binaryOperand;}
[0-9]+							{yylval.string = strdup(yytext); return integer;}
[0-9]+[.][0-9]+						{yylval.string = strdup(yytext); return real;}
[ \{\}\[\]\(\)\|&!=;:,]				{return yytext[0];}
[a-zA-Z][a-zA-Z0-9]*						{yylval.string = strdup(yytext); return identifier;}
[\n\t]							;
.							{ECHO; yyerror("unexpected character");}
%%
int yywrap(void) {return 1;}

