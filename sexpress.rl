
#include "sexpress.h"

#define ALLOC if (sexpress->p == sexpress->pe) {                    \
    size_t offsetp = sexpress->p - sexpress->buffer;                \
    size_t new_size = 2 * offsetp;                        \
    sexpress->buffer = (char *)realloc(sexpress->buffer, new_size); \
    sexpress->p = sexpress->buffer + offsetp;                       \
	sexpress->pe = sexpress->buffer + new_size;                     \
}

%%{

  machine sexpress;
  access sexpress->;

  prepush {
    fprintf(stderr, "prepush\n");
  }

  postpop {
    fprintf(stderr, "postpop\n");
  }

  action token {
      if (sexpress->p > sexpress->buffer) {
          *sexpress->p = '\0';
          printf("Type %d\n", sexpress->type);
          sexpress->field(sexpress->buffer);
          sexpress->p = sexpress->buffer;
          sexpress->type = 0;
      }
  }

  action nil   {}
  action get   { *sexpress->p++ = *p; sexpress->type |= STR;  ALLOC; }
  action geta  { *sexpress->p++ = *p; sexpress->type |= ATOM; ALLOC; }
  action getn  { *sexpress->p++ = *p; sexpress->type |= DEC;  ALLOC; }
  action push  { printf("push\n"); }
  action pop   { printf("pop\n"); }

  ATOM   = [a-zA-Z][a-zA-Z0-9_]*;
  LPAR   = '(';
  RPAR   = ')';
  QUOTE  = '"';
  NIL    = 'NIL';
  PRINT  = print - QUOTE;
  SPACE  = [ ];
  STRING = QUOTE (PRINT >get)* QUOTE;
  TOKEN  = ATOM >geta | digit+ >getn | STRING;
  # TOKEN  = digit+;
  C2 = (
    start: (
      SPACE* -> lpar
    ),
    lpar: (
      LPAR  $push @{ fcall sexpress; } -> lpar  |
      RPAR  $token $pop @{ fret; }     -> final |
      SPACE $token                     -> lpar  |
      TOKEN                            -> lpar
    )
  );

sexpress := C2;

}%%

%%write data;

sexpress_t* sexpress_new(size_t buffer_size, void (*field)(char *data),
                                   void (*record_end)(void)) {
    sexpress_t *sexpress = (sexpress_t*) malloc(sizeof(sexpress_t));
    sexpress->stack  = (int *) malloc(20);
    sexpress->stacke = sexpress->stack + 20;
    sexpress->buffer = (char *) malloc(buffer_size);
    sexpress->p = sexpress->buffer;
    sexpress->pe = sexpress->buffer + buffer_size;
    sexpress->field = field;
    sexpress->record_end = record_end;
    sexpress->type = 0;
    %%write init;
    return sexpress;
}

void sexpress_free(sexpress_t *sexpress) {
    free(sexpress->buffer);
    free(sexpress->stack);
    free(sexpress);
}

int sexpress_scan(sexpress_t *sexpress, char const *data, size_t len) {
    char const *p = data;
    char const *pe = data + len;
    char const *eof = pe;
    %%write exec;
    return 0;
}
