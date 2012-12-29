#ifndef INCLUDE_GUARD_SEXPRESS
#define INCLUDE_GUARD_SEXPRESS

#ifdef __cplusplus
extern "C"
{
#endif

#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int cs;
    int top;
    int *stack;
    int *stacke;
    char *p;
    char *pe;
    char const *ts;
    char const *te;
    int act;
    char *buffer;
    int type;

    void (*field)(char *data);
    void (*record_end)(void);
    void (*error)(char const *message);
} sexpress_t;

enum sexpress_token_t { DEC = 1, STR = 2, ATOM = 4 };

sexpress_t* sexpress_new(size_t buffer_size, void (*field)(char *data),
                                   void (*record_end)(void),
                                   void (*error)(char const *message));
void sexpress_free(sexpress_t *sexpress);
int sexpress_scan(sexpress_t* sexpress, char const *data, size_t len);

#ifdef __cplusplus
}
#endif

#endif /* INCLUDE_GUARD_SEXPRESS */
/* $Id$ */
