#include <stdlib.h>
#include <stdio.h>
#include "map_stack.h"

MapStack map_stack_create() {
	MapStack map_stack = (MapStack) malloc(sizeof(map_stack_header));
	map_stack->first = NULL;
	return map_stack;
}

map_stack_node * map_stack_new_node(Map map, map_stack_node * next) {
	map_stack_node * node = (map_stack_node *) malloc(sizeof(map_stack_node));
	node->map = map;
	node->next = next;
	return node;
}

void map_stack_push(MapStack map_stack, Map map) {
	map_stack_node * new = map_stack_new_node(map, map_stack->first);
	map_stack->first = new;
}

Map map_stack_pop(MapStack map_stack) {
	map_stack_node * first = map_stack->first;
	Map ans;
	if (first == NULL) return NULL;
	map_stack->first = first->next;
	ans = first->map;
	free(first);
	return ans;
}

Map map_stack_peek(MapStack map_stack) {
	map_stack_node * first = map_stack->first;
	if (first == NULL) return NULL;
	return first->map;
}

void map_stack_free(MapStack map_stack) {
	map_stack_free_rec(map_stack->first);
	free(map_stack);
}

void map_stack_free_rec(map_stack_node * node) {
	if (node == NULL) return;
	map_stack_node * next = node->next;
	map_free(node->map);
	free(node);
	map_stack_free_rec(next);
}

void map_stack_print(MapStack map_stack) {
	map_stack_print_rec(map_stack->first);
}

void map_stack_print_rec(map_stack_node * node) {
	if (node == NULL) return;
	map_print(node->map);
	printf("--------------\n");
	map_stack_print_rec(node->next);
}
