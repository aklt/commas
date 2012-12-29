
#include "csv.h"

#define ALLOC if (csv->p == csv->pe) {                    \
    size_t offsetp = csv->p - csv->buffer;                \
    size_t new_size = 2 * offsetp;                        \
    csv->buffer = (char *)realloc(csv->buffer, new_size); \
    csv->p = csv->buffer + offsetp;                       \
    csv->pe = csv->buffer + new_size;                     \
}

%%{

  machine csv;
  access csv->;

  action token {
      *csv->p = '\0';
      csv->field(csv->buffer);
      csv->p = csv->buffer;
      csv->column += 1;
  }

  action get    { *csv->p++ = *p; ALLOC; }
  action record { csv->record_end(); csv->line += 1; csv->column = 1; }
  action getq   { *csv->p++ = '"'; ALLOC; }
  action error  {
      if (csv->errbuf == 0) {
          csv->errbuf = (char *) malloc(512);
      }
      snprintf(csv->errbuf, 512, "ERROR on line %d column %d", csv->line,
                                                               csv->column);
      csv->error(csv->errbuf);
  }

  DQUOTE = "\"";
  TEXTDATA = 0x20..0x21 | 0x23..0x2b | 0x2d..0x7e;
  COMMA = ",";
  CR = "\r";
  LF = "\n";
  escaped = DQUOTE ( TEXTDATA >get | COMMA >get | CR >get | LF >get | DQUOTE{2} @getq )* DQUOTE;
  non_escaped = TEXTDATA* @get;
  field = ( escaped | non_escaped);
  CRLF = CR LF @token @record;
  record = field ( COMMA @token field )*;
  file = record ( CRLF record )* CRLF? $err(error);

csv := file;

}%%

%%write data;

csv_t* csv_new(size_t buffer_size, void (*field)(char *data),
                                   void (*record_end)(void),
                                   void (*error)(char const *message)) {
    csv_t *csv = (csv_t*) malloc(sizeof(csv_t));
    csv->buffer = (char *) malloc(buffer_size);
    csv->p = csv->buffer;
    csv->pe = csv->buffer + buffer_size;
    csv->line = 1;
    csv->column = 1;
    csv->errbuf = 0;
    csv->field = field;
    csv->record_end = record_end;
    csv->error = error;
    %%write init;
    return csv;
}

void csv_free(csv_t *csv) {
    free(csv->buffer);
    if (csv->errbuf) {
        free(csv->errbuf);
    }
    free(csv);
}

int csv_scan(csv_t *csv, char const *data, size_t len) {
    char const *p = data;
    char const *pe = data + len;
    char const eof = pe;
    %%write exec;
    return 0;
}
