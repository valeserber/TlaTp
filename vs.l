%{
#include "vs.tab.h"
%}
%%
"\""[ a-zA-Z0-9|&!+-=;:,]*"\""				{yylval.string = strdup(yytext); return string;}
"$0"|"$"[1-9][0-9]*					{yylval.string = strdup(yytext); return argToken;}
"^i"							{return toIntegerCastToken;}
"^d"							{return toDoubleCastToken;}
"^c"							{return castToken;}
"println"						{return println;}
"print"							{return print;}
"read"							{return readToken;}
"rand"							{return randToken;}
"return"						{return ret;}
"function"						{return function;}
"main"							{return mainToken;}
"if"							{return ifToken;}
"else"							{return elseToken;}
"while"							{return whileToken;}
"null"							{return nullToken;}
"Integer"|"String"|"Object"|"Boolean"|"Double"|"void"|"Integer[]"|"String[]"|"Object[]"|"Boolean[]"|"Double[]" {yylval.string = strdup(yytext);return type;}
"true"|"false"					{yylval.string = strdup(yytext);return boolean;}
"=="							{yylval.string = strdup(yytext);return equals;}
"<="|">="|"<"|">"				{yylval.string = strdup(yytext);return comparator;}
"&&"|"||"						{yylval.string = strdup(yytext);return booleanBinaryOperand;}
"+"|"-"|"*"|"%"|"/"|"^"			{yylval.string = strdup(yytext);return binaryOperand;}
[0-9]+							{yylval.string = strdup(yytext); return integer;}
[0-9]+[.][0-9]+						{yylval.string = strdup(yytext); return real;}
[ \{\}\[\]\(\)\|&!=;:,.#]				{return yytext[0];}
[a-zA-Z][a-zA-Z0-9]*					{yylval.string = strdup(yytext); return identifier;}
[\n\t]							;
.							{ECHO; yyerror("unexpected character");}
%%
int yywrap(void) {return 1;}

