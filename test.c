
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <getopt.h>

#include "csv.h"

static void print_field(char *data) {
    fprintf(stderr, "%s ", data);
}

static void print_record_end(void) {
    fprintf(stderr, "\n");
}

int main(int argc, char **argv) {
    int opt;
    char buffer[1024];
    char inputFilename[256] = "-\0";
    FILE *argInput = stdin;
    size_t argChunkSize = 1;
	size_t haveRead;

	csv_t *c1 = csv_new(1, print_field, print_record_end);

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
        csv_scan(c1, buffer, haveRead);
    }
	csv_free(c1);
	return 0;
}
/* $Id$ */
