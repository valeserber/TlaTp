#ifndef _MAP_STACK_H_
#define _MAP_STACK_H_

#include "map.h"

struct map_stack_node {
	Map map;
	struct map_stack_node * next;
};

typedef struct map_stack_node map_stack_node;

struct map_stack_header {
	map_stack_node * first;
};

typedef struct map_stack_header map_stack_header;
typedef map_stack_header * MapStack;

//FUNCTIONS

MapStack map_stack_create();
map_stack_node * map_stack_new_node(Map map, map_stack_node * next);
void map_stack_push(MapStack map_stack, Map map);
Map map_stack_pop(MapStack map_stack);
Map map_stack_peek(MapStack map_stack);
void map_stack_free(MapStack map_stack);
void map_stack_free_rec(map_stack_node * node);
void map_stack_print(MapStack map_stack);
void map_stack_print_rec(map_stack_node * node);

#endif
