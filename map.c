#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "map.h"

Map map_create() {
	Map map = (Map) malloc(sizeof(map_header));
	map->first = NULL;
	return map;
}

map_node * map_new_node(char * key, char * value, map_node * next) {
	map_node * new_node = (map_node *) malloc(sizeof(map_node));
	new_node->key = key;
	new_node->value = value;
	new_node->next = next;
	return new_node;
}

void map_put(Map map, char * key, char * value) {
	map_node * new_node = map_new_node(key, value, map->first);
	map->first = new_node;
}

char * map_get(Map map, char * key) {
	return map_get_rec(map->first, key);
}

char * map_get_rec(map_node * node, char * key) {
	if (node == NULL) return NULL;
	if ( strcmp( key, node->key ) == 0 ) {
		return node->value;
	}
	return map_get_rec(node->next, key);

}

void map_print(Map map) {
	map_print_rec(map->first);
}

void map_print_rec(map_node * node) {
	if (node == NULL) return;
	printf("key: %s\nvalue: %s\n\n", node->key, node->value);
	map_print_rec(node->next);
}

void map_free(Map map) {
	map_free_rec(map->first);
	free(map);
}

void map_free_rec(map_node * node) {
	if (node == NULL) return;
	map_node * next = node->next;
	free(node);
	map_free_rec(next);
}
