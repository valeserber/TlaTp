%{
void yyerror (char * s);
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "map.h"
#include "map_stack.h"
#include "utils.h"

#define STATIC 1
#define OBJECT 2

static MapStack map_stack;

static char * throwsDeclaration = " throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, NoSuchMethodException, InvocationTargetException, IOException";
static char * method = "method";
static char * field = "field";
static char * accessible = ".setAccessible(true);";

void init();
char * check_cast(char * id, char * value);
char * check_identifier(char * id);
void save_identifier(char * id, char * value);

void create_map();
void destroy_map();

char * concat2(char * s1, char * s2);
char * concat3(char * s1, char * s2, char * s3);
char * concat4(char * s1, char * s2, char * s3, char * s4);
char * concat5(char * s1, char * s2, char * s3, char * s4, char * s5);
char * concat6(char * s1, char * s2, char * s3, char * s4, char * s5, char * s6);

char * composeFunction(int modifier, char * type, char * identifier, char * arguments, char * lines);
char * composeMain(char * lines);
char * composeObjectValue(char * variableSection, char * methodSection);

char * composeVariableAccess(char * varAccess, char * id);
char * composeObjectFunctionCall(char * obj, char * method, char * args);

void printFile(char * file);
%}

%union {int integer; char * string; double real; char character;}
%start file

%token castToken;
%token toIntegerCastToken
%token toDoubleCastToken
%token print
%token readToken
%token println
%token ret;
%token nullToken
%token function
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
%token <string> equals
%token <string> argToken

%type <string> ifProd
%type <string> elseProd
%type <string> whileProd
%type <string> assignment
%type <string> assignation
%type <string> declaration
%type <string> value
%type <string> operationalValue
%type <string> stringValue
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
%type <string> printProd
%type <string> printlnProd
%type <string> readProd
%type <string> toDoubleCastProd
%type <string> toIntegerCastProd
%type <string> arrayAccess
%type <string> arrayNew
%type <string> castProd

%%

file		: ms staticFunctions ms mainFunction ms				{$$ = concat3($2, "\n\n", $4); printFile($$);}
		| ms mainFunction ms						{$$ = $2; printFile($$);}
		;

mainFunction	: mapCreator mainToken ms '{' lines '}'					{destroy_map();
			  								$$ = composeMain($5);}
		;

staticFunctions	: staticFunction						{$$ = $1;}
		| staticFunctions ms staticFunction				{$$ = concat3($1, "\n", $3);}
		;

staticFunction	: mapCreator type ms identifier ms argumentsDeclarPack ms '{' ms lines ms '}' ms {destroy_map();
			  									$$ = composeFunction(STATIC, $2, $4, $6, $10);}
		;

mapCreator	: /* empty */							{create_map();}
		;

objectFunction 	: function ' ' ms type ms identifier ms argumentsDeclarPack ms '{' ms lines ms '}' ms 	{$$ = composeFunction(OBJECT, $4, $6, $8, $12);}
		;

argumentsDeclarPack	: '(' ')'						{$$ = "()";}
			| '(' argumentsDeclar ')'				{$$ = concat3("( ", $2, " )");}
			;

argumentsDeclar	: ms argumentDeclar ms						{$$ = $2;}
		| ms argumentDeclar ms ',' ms  argumentsDeclar ms		{$$ = concat3($2, ", ", $6);}
		;

argumentDeclar	: type ' ' ms identifier					{save_identifier($4, $1);
			  							$$ = concat4("final ", "Object", " ", $4);}
		;

lines		: /* empty */							{$$ = "";}
		| line								{$$ = $1;}
		| line ms lines							{$$ = concat3($1, "\n", $3);}
		| returnStatement						{$$ = $1;}
		;

line		: ';'								{$$ = ";";}
		| newVar ';'							{$$ = concat2($1, ";");}
		| assignment ';'						{$$ = concat2($1, ";");}
		| functionCall ';'						{$$ = concat2($1, ";");}
		| ifProd							{$$ = $1;}		
		| whileProd							{$$ = $1;}
		| printProd							{$$ = $1;}
		| printlnProd						{$$ = $1;}
		;

ifProd		: ifToken ms '(' ms value ms ')' ms '{' ms lines ms '}' elseProd	{$$ = concat6("if (", $5, ") {\n\t", $11, "\n\t}", $14);}
			;

elseProd	: /* empty */							{$$ = "";} 
			| elseToken ms '{' ms lines ms '}'				{$$ = concat3("else {\n\t", $5, "\n\t}");}
			;

whileProd	: whileToken ms '(' ms value ms ')' ms '{' ms lines ms '}' {$$ = concat5("while(", $5, ") {\n\t", $11, "\n\t}");}
 			;

printProd	: print ms '(' ms value ms ')' ms ';'				{$$ = concat3("System.out.print(", $5, ");");}
		;

printlnProd	: println ms '(' ms value ms ')' ms ';'				{$$ = concat3("System.out.println(", $5, ");");}
		| println ms '(' ms ')' ms ';'					{$$ = "System.out.println();";}
		;

returnStatement	: ret ' ' ms value ms ';'					{$$ = concat3("return ", $4, ";");}
		| ret ms ';'							{$$ = "return;";}
		;

assignment	: identifier ms '=' ms value ms					{$$ = concat3($1, " = ", check_cast($1, $5));}
		| arrayAccess ms '=' ms value ms				{$$ = concat3($1, "=", $5);}
		;

assignation	: type ' ' ms identifier ms '=' ms value ms			{save_identifier($4, $1);
			  							$$ = concat4($1, " ", $4, " = ");
		  								$$ = concat6($$, "((", $1, ")", $8, ")");}
		;

declaration	: type ' ' ms identifier					{ save_identifier($4, $1);
			  							$$ = concat3($1, " ", $4);}
		;

newVar		: assignation							{$$ = $1;}
		| declaration							{$$ = $1;}
		;

value		: nullToken							{$$ = "null";}
		| toResolveExp							{$$ = $1;}
		| integerValue							{$$ = $1;}
		| stringValue							{$$ = $1;}
		| doubleValue							{$$ = $1;}
		| booleanValue							{$$ = $1;}
		| operationalValue                      {$$ = $1;}
		| objectValue							{$$ = $1;}
		| arrayAccess							{$$ = $1;}
		| arrayNew							{$$ = $1;}
		| castToken type '#' value					{$$ = concat5("((", $2, ")", $4, ")");}
		;

arrayAccess	: identifier '[' value ']'					{$$ = concat4($1, "[((Integer)", $3, ")]");}
		;

arrayNew	: type '[' value ']'						{$$ = concat5("(new ", $1, "[((Integer)", $3, ")])");}
		;

operationalValue	: toResolveExp						{$$ = $1;}
			| integerValue						{$$ = $1;}
			| doubleValue						{$$ = $1;}
            | '(' ms operationalValue ms binaryOperand ms operationalValue ms ')' {$$ = concat5("(", $3, $5, $7, ")");}	
			;


stringValue	: string							{$$ = $1;}
		| readToken							{$$ = "(new BufferedReader(new InputStreamReader(System.in))).readLine()";}
		| argToken							{$$ = concat3("args[", $1 + 1, "]");}
		| toResolveExp							{$$ = $1;}
		;

integerValue	: integer							{$$ = concat3("((Integer)",$1, ")");}
        	| integerReturnable                 				{$$ = $1;}	
		| toIntegerCastProd						{$$ = $1;}
		;

toIntegerCastProd	: toIntegerCastToken stringValue			{$$ = concat3("(Integer.valueOf((String)", $2, "))");}
			;

doubleValue	: real								{$$ = concat3("((Double)",$1, ")");}
		| toDoubleCastProd						{$$ = $1;}
		| doubleReturnable              				{$$ = $1;}
		;

toDoubleCastProd	: toDoubleCastToken stringValue				{$$ = concat3("(Double.valueOf((String)", $2, "))");}
			;

booleanValue	: booleanReturnable							{$$ = $1;}
		| '(' ms value ms booleanBinaryOperand ms value ms ')'		{$$ = concat5("(", $3, $5, $7, ")");}
		| '!' booleanValue							{$$ = concat2("!", $2);}
		;

booleanReturnable	: boolean						{$$ = $1;}
			| toResolveExp						{$$ = $1;}
			| comparison						{$$ = $1;}
			| value equals value					{$$ = concat4($1, ".equals(", $3, ")");}
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


objectValue	: '{' variableSection methodSection'}'				{$$ = composeObjectValue($2, $3);}
		;

variableSection	: /* empty */							{$$ = "";}
		| newVar ';'							{$$ = concat2($1,";");}
		| variableSection newVar ';'					{$$ = concat4($1, "\n", $2, ";");}
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

variableAccess	: variableAccess '.' identifier					{$$ = composeVariableAccess($1, $3);}
		| identifier '.' identifier					{$$ = composeVariableAccess($1, $3);}
		;

totalIdentifier	: identifier							{$$ = check_identifier($1);}
		| variableAccess						{$$ = $1;}
		;

objectFunctionCall 	: totalIdentifier ':' identifier '(' ')'		{$$ = composeObjectFunctionCall($1, $3, NULL);}
			| totalIdentifier ':' identifier '(' argumentsCall ')' 	{$$ = composeObjectFunctionCall($1, $3, $5);}
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

staticFunctionCall	: identifier argumentsCallPack				{$$ = concat3("VSClass.",$1, $2);}
			;

ms		: /* empty */							{;}
		| ' '								{;}
		| ms ' '							{;}
		;

%%

int main(void) {
	init();
	return yyparse();
}

void init() {
	map_stack = map_stack_create();
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

void printFile(char * file) {
	printf("%s\n", concat3("import java.io.BufferedReader;import java.io.IOException;import java.io.InputStreamReader;import java.lang.reflect.InvocationTargetException;public class VSClass {", file, "}"));
}

char * composeMain(char * lines) {
	return concat5("public static void main(String[] args) ", throwsDeclaration, " {\n", lines, "\n}\n");
}

char * composeObjectValue(char * variableSection, char * methodSection) {
	return concat4("new Object() {", variableSection, methodSection, "}");
}

char * check_identifier(char * id) {
	Map map = map_stack_peek(map_stack);
	char * type;
	if (map == NULL) {
		printf("%s\n", id);
		printf("intente hacer check. que carajo hago aca?\n");
		return id;
	};
	type = map_get(map, id);
	if (type == NULL) return id;
	return concat5("((", type, ")", id, ")");
}

void save_identifier(char * id, char * value) {
	Map map = map_stack_peek(map_stack);
	if (map == NULL) {
		printf("intente hacer save. que carajo hago aca?\n");
		return;
	}
	map_put(map, id, value);
}

void create_map() {
	map_stack_push(map_stack, map_create());
}

void destroy_map() {
	Map map = map_stack_pop(map_stack);
	if (map == NULL) {
		printf("intente destruir y no habia nada. wtf?\n");
		return;
	}
	map_free(map);
}

char * composeObjectFunctionCall(char * obj, char * meth, char * args) {

	int amount = 0;
	int i;
	char * lastLine;
	char * firstLine;
	char * accessible;
	char ** tokens;
	if ( args != NULL && !(strcmp(args, "()") == 0) ) {
		tokens = str_split(strdup(args), ',');
		amount = tokens_amnt(tokens);
	}
	firstLine = concat2(obj, ".getClass().getDeclaredMethod(");
	firstLine = concat4(firstLine, "\"", meth, "\"");
	lastLine = concat2(".invoke(", obj);
	for (i = 0; i < amount; i++) {
		firstLine = concat2(firstLine, ", Object.class");
		lastLine = concat3(lastLine, ", ", get_token(tokens, i));
	}
	firstLine = concat2(firstLine, ")");
	lastLine = concat2(lastLine, ")");
	accessible = "method.setAccessible(true);";
	return concat2(firstLine, lastLine);
}

char * check_cast(char * id, char * value) {

	Map map = map_stack_peek(map_stack);
	char * type;
	if (map == NULL) {
		printf("%s\n", id);
		printf("intente hacer checkc. que carajo hago aca?\n");
		return value;
	};
	type = map_get(map, id);
	if (type == NULL) return value;
	return concat5("((", type, ")", value, ")");
}

char * composeVariableAccess(char * varAccess, char * id) {
	char * s = concat4(varAccess, ".getClass().getDeclaredField(\"", id, "\")");
	s = concat4(s, ".get(", varAccess, ")");
	return s;
}
