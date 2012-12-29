
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <getopt.h>

#include "csv.h"
#include "sexpress.h"

#ifndef MACHINE
#  error "Macro MACHINE must be defined"
#else
#  define MAKER(x, y) x ## _ ## y
#  define EVAL(x, y) MAKER(x, y)
#  define NAME(fun) EVAL(MACHINE,fun)

#  define NEW  NAME(new)
#  define FREE NAME(free)
#  define SCAN NAME(scan)
#  define STRUCT_T NAME(t)
#endif

static void print_field(char *data) {
    fprintf(stderr, "'%s'", data);
}

static void print_record_end(void) {
    fprintf(stderr, "\n");
}

static void print_error(char const *message) {
    fprintf(stderr, "%s\n", message);
}

int main(int argc, char **argv) {
    int opt;
    char buffer[1024];
    char inputFilename[256] = "-\0";
    FILE *argInput = stdin;
    size_t argChunkSize = 1;
    size_t haveRead;

    STRUCT_T *c1 = NEW(1, print_field, print_record_end, print_error);

    while ((opt = getopt(argc, argv, "s:i:h")) != -1) {

        switch (opt) {
        case 's':
            argChunkSize = atoi(optarg);
            break;
        case 'i':
            if (strlen(optarg) > 1 || strncmp(optarg, "-", 1) != 0) {
                strncpy(inputFilename, optarg, strlen(optarg));
                argInput = fopen(inputFilename, "r");
                if (!argInput) {
                    printf("Could not open file: %s\n", inputFilename);
                    exit(1);
                }
            }
            break;
        case 'h':
            printf("Usage: test1 -s <N>        Chunk size\n"
                   "             -i <filename> Input file\n"
                   "             -h            Show help\n");
            exit(0);
            break;
        default:
            printf("Unknown arg %s\n", optarg);
        }
    }

    while ((haveRead = fread(buffer, 1, argChunkSize, argInput)) > 0) {
        buffer[haveRead] = '\0';
        /*fprintf(stderr, "Read %d %s\n", haveRead, buffer);*/
        SCAN(c1, buffer, haveRead);
    }
    FREE(c1);
    return 0;
}
/* $Id$ */
