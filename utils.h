#ifndef _UTILS_H_
#define _UTILS_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

int tokens_amnt(char ** tokens);
char * get_token(char ** tokens, int i);
char** str_split(char* a_str, const char a_delim);

#endif
