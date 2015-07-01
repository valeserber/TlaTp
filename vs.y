%{
void yyerror (char * s);
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define STATIC 1
#define OBJECT 2

static char * throwsDeclaration = " throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException";

char * concat2(char * s1, char * s2);
char * concat3(char * s1, char * s2, char * s3);
char * concat4(char * s1, char * s2, char * s3, char * s4);
char * concat5(char * s1, char * s2, char * s3, char * s4, char * s5);
char * concat6(char * s1, char * s2, char * s3, char * s4, char * s5, char * s6);

char * composeFunction(int modifier, char * type, char * identifier, char * arguments, char * lines);
%}

%union {int integer; char * string; double real; char character;}
%start file

%token print
%token ret;
%token function;
%token mainToken
%token ifToken
%token elseToken
%token whileToken
%token <string> integer
%token <string> real
%token <string> boolean
%token <string> string
%token <string> identifier
%token <string> type
%token <string> comparator
%token <string> booleanBinaryOperand
%token <string> binaryOperand
%type <string> ifProd
%type <string> elseProd
%type <string> whileProd
%type <string> assignment
%type <string> assignation
%type <string> declaration
%type <string> value
%type <string> operationalValue
%type <string> integerValue
%type <string> doubleValue
%type <string> numberValue
%type <string> booleanValue
%type <string> booleanReturnable
%type <string> integerReturnable
%type <string> doubleReturnable
%type <string> objectValue
%type <string> comparable
%type <string> comparison
%type <string> operation
%type <string> variableAccess
%type <string> objectFunctionCall
%type <string> staticFunctionCall
%type <string> functionCall
%type <string> totalIdentifier
%type <string> argumentsCallPack
%type <string> argumentsCall
%type <string> argumentsDeclarPack
%type <string> argumentsDeclar
%type <string> argumentDeclar
%type <string> toResolveExp
%type <string> line
%type <string> lines
%type <string> file
%type <string> staticFunctions
%type <string> mainFunction
%type <string> staticFunction
%type <string> objectFunction
%type <string> returnStatement
%type <string> newVar
%type <string> variableSection
%type <string> methodSection

%%

file		: ms staticFunctions ms mainFunction ms				{;}
		| ms mainFunction ms						{;}
		;

mainFunction	: mainToken ms '{' lines '}'					{printf("main\n");}
		;

staticFunctions	: staticFunction						{$$ = $1;}
		| staticFunction ms staticFunctions				{$$ = concat3($1, "\n", $3);}
		;

staticFunction	: type ms identifier ms argumentsDeclarPack ms '{' ms lines ms '}' ms 	{$$ = composeFunction(STATIC, $1, $3, $5, $9);printf("%s\n", $$);}
		;

objectFunction 	: function ' ' ms type ms identifier ms argumentsDeclarPack ms '{' ms lines ms '}' ms 	{$$ = composeFunction(OBJECT, $4, $6, $8, $12);}
		;

argumentsDeclarPack	: '(' ')'						{$$ = "()";}
			| '(' argumentsDeclar ')'				{$$ = concat3("( ", $2, " )");}
			;

argumentsDeclar	: ms argumentDeclar ms						{$$ = $2;}
		| ms argumentDeclar ms ',' ms argumentsDeclar ms		{$$ = concat3($2, ", ", $6);}
		;

argumentDeclar	: type ' ' ms identifier					{;}
		;

lines		: /* empty */							{$$ = "";}
		| line								{$$ = concat2("\t", $1);}
		| line ms lines							{$$ = concat4("\t", $1, "\n", $3);}
		| returnStatement						{$$ = concat2("\t", $1);}
		;

line		: ';'								{$$ = ";";}
		| newVar ';'							{$$ = concat2($1, ";");}
		| assignment ';'						{$$ = concat2($1, ";");}
		| functionCall ';'						{$$ = concat2($1, ";");}
		| ifProd							{$$ = $1;}		
		| whileProd							{$$ = $1;}
		;

ifProd		: ifToken ms '(' ms booleanValue ms ')' ms '{' ms lines ms '}' elseProd	{$$ = concat6("if ", $5, " {\n\t", $11, "\n\t}", $14);}
		;

elseProd	: /* empty */							{$$ = "";} 
		| elseToken ms '{' ms lines ms '}'				{$$ = concat3("else {\n\t", $5, "\n\t}");}
		;

whileProd	: whileToken ms '(' ms booleanValue ms ')' ms '{' ms lines ms '}' {$$ = concat5("while ", $5, " {\n\t", $11, "\n\t}");}
		;

returnStatement	: ret ' ' ms value ms ';'					{$$ = concat3("return ", $4, ";");}
		| ret ms ';'							{$$ = "return;";}
		;

assignment	: identifier ms '=' ms value ms					{$$ = concat3($1, " = ", $5);}
		;

assignation	: type ' ' ms identifier ms '=' ms value ms			{$$ = concat5($1, " ", $4, " = ", $8);}
		;

newVar		: assignation							{$$ = $1;}
		| declaration							{$$ = $1;}
		;

value		: toResolveExp							{$$ = $1;}
		| integerValue							{$$ = $1;}
		| doubleValue							{$$ = $1;}
		| booleanValue							{$$ = $1;}
        | operationalValue                      {$$ = $1;}
		| objectValue							{$$ = $1;}
		;

operationalValue	: toResolveExp						{$$ = $1}
			| integerValue						{$$ = $1}
			| doubleValue						{$$ = $1}
            | '(' ms operationalValue ms binaryOperand ms operationalValue ms ')' {$$ = concat5("(", $3, $5, $7, ")");}	
			;

integerValue	: integer							{$$ = $1;}
                | integerReturnable                 				{$$ = $1;}	
                ;

doubleValue	: real								{$$ = $1;}
  	        | doubleReturnable              				{$$ = $1;}
            ;

booleanValue	: booleanReturnable							{$$ = $1;}
		| '(' ms booleanValue ms booleanBinaryOperand ms booleanValue ms ')'	{$$ = concat5("(", $3, $5, $7, ")");}
		| '!' booleanValue							{$$ = concat2("!", $2);}
		;

booleanReturnable	: boolean						{$$ = $1;}
			| toResolveExp						{$$ = $1;}
			| comparison						{$$ = $1;}
			| '(' ms booleanReturnable ms ')'			{$$ = concat3("(", $3, ")");}
			;

integerReturnable   : integer            					{$$ = $1;}
                    | toResolveExp             					{$$ = $1;}
                    | operation                					{$$ = $1;}
                    | '(' ms integerReturnable ms ')'				{$$ = concat3("(", $3, ")");}
                    ;

doubleReturnable    : real               				{$$ = $1;}
                    | toResolveExp             					{$$ = $1;}
                    | operation                 				{$$ = $1;}
                    | '(' ms doubleReturnable ms ')'				{$$ = concat3("(", $3, ")");}
                    ;

objectValue	: '{' variableSection methodSection'}'				{;}
		;

variableSection	: /* empty */							{$$ = "";}
		| newVar ';'							{$$ = concat2($1,";");}
		| newVar ';' variableSection					{$$ = concat3($1, ";\n", $3);}
		;

methodSection	: /* empty */							{$$ = "";}
		| objectFunction						{$$ = concat2($1, "\n");}
		| objectFunction ms methodSection				{$$ = concat3($1, "\n", $3);}					
		;

comparison	: value comparator value					{$$ = concat5("(", $1, $2, $3, ")");}
		;

operation	: operationalValue binaryOperand operationalValue		{$$ = concat5("(", $1, $2, $3, ")");}
		    ;

numberValue	: integerValue							{$$ = $1;}
		| doubleValue							{$$ = $1;}
		;

comparable	: identifier							{$$ = $1;}
		| variableAccess						{$$ = $1;}
		| objectFunctionCall						{$$ = $1;}
		;

variableAccess	: identifier '.' variableAccess					{$$ = concat3($1, ".", $3);}
		| identifier '.' identifier					{$$ = concat3($1, ".", $3);}
		;

totalIdentifier	: identifier							{$$ = $1;}
		| variableAccess						{$$ = $1;}
        ;

objectFunctionCall 	: totalIdentifier ':' staticFunctionCall		{$$ = concat3($1, ".", $3);}
			;

argumentsCallPack	: '(' ')'						{$$ = "()";}
			| '(' argumentsCall ')'					{$$ = concat3("( ", $2, " )");}
			;

argumentsCall	: ms value ms							{$$ = $2;}
		| ms value ms ',' ms argumentsCall ms				{$$ = concat3($2, ", ", $6);}
		;

toResolveExp	: totalIdentifier						{$$ = $1;}
		| functionCall							{$$ = $1;}
		;

functionCall	: objectFunctionCall						{$$ = $1;}
		| staticFunctionCall						{$$ = $1;;}
		;

staticFunctionCall	: identifier argumentsCallPack				{$$ = concat2($1, $2);}

declaration	: type ' ' ms identifier					{$$ = concat3($1, " ", $4);}

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

char * concat2(char * s1, char * s2) {
    size_t len1 = strlen(s1);
    size_t len2 = strlen(s2);
    char *result = malloc(len1+len2+1);//+1 for the zero-terminator
    //in real code you would check for errors in malloc here
    memcpy(result, s1, len1);
    memcpy(result+len1, s2, len2+1);//+1 to copy the null-terminator
    return result;
}

char * concat3(char * s1, char * s2, char * s3) {
	return concat2(concat2(s1, s2), s3);
}

char * concat4(char * s1, char * s2, char * s3, char * s4) {
	return concat2(concat3(s1, s2, s3), s4);
}

char * concat5(char * s1, char * s2, char * s3, char * s4, char * s5) {
	return concat2(concat4(s1, s2, s3, s4), s5);
}

char * concat6(char * s1, char * s2, char * s3, char * s4, char * s5, char * s6) {
	return concat2(concat5(s1, s2, s3, s4, s5), s6);
}

char * composeFunction(int modifier, char * type, char * identifier, char * arguments, char * lines) {
	char * first;
	if (modifier == STATIC) {
		first = "public static ";
	} else {
		first = "public ";
	}
	char * signatureMiddle = concat4(first, type, " ", identifier);
	char * signatureFinal = concat4(signatureMiddle, arguments, throwsDeclaration, " {\n");
	return concat3(signatureFinal, lines, "\n}");
}
