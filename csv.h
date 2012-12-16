#ifndef INCLUDE_GUARD_CSV
#define INCLUDE_GUARD_CSV

#ifdef __cplusplus
extern "C"
{
#endif

#include <stdio.h>
#include <stdlib.h>

typedef struct {
	int cs;
	char *p;
	char *pe;
	char *buffer;
	void (*field)(char *data);
	void (*record_end)(void);
} csv_t;

csv_t* csv_new(size_t buffer_size, void (*field)(char *data),
                                   void (*record_end)(void));
void csv_free(csv_t *csv);
int csv_scan(csv_t* csv, char const *data, size_t len);

#ifdef __cplusplus
}
#endif

#endif /* INCLUDE_GUARD_CSV */
/* $Id$ */
