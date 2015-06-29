#ifndef _MAP_H_
#define _MAP_H_

struct map_node {
	char * key;
	char * value;
	struct map_node * next;
};

typedef struct map_node map_node;

struct map_header {
	map_node * first;
};

typedef struct map_header map_header;
typedef map_header * Map;

//FUNCTIONS

Map map_create();
map_node * map_new_node(char * key, char * value, map_node * next);
void map_put(Map map, char * key, char * value);
char * map_get(Map map, char * key);
char * map_get_rec(map_node * node , char * key);
void map_print(Map map);
void map_print_rec(map_node * node);
void map_free(Map map);
void map_free_rec(map_node * node);

#endif
