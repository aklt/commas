
RAGEL_OPTS=-s -m -G2
CFLAGS=-Wall -pedantic -O2

.SUFFIXES: %.s
.PRECIOUS: %.c

all: test-csv test-sexpress csv.png sexpress.png

test-%: test.c %.o
	$(CC) -DMACHINE=$* $(CFLAGS) -o $@ $^

%.png: %.dot
	dot -Tpng -o $@ $<

%.dot: %.rl
	ragel $(RAGEL_OPTS) -Vp $< > $@

%.s: %.c
	$(CC) $(CFLAGS) -S -o $@ $<

%: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.c: %.rl
	ragel $(RAGEL_OPTS) $<

clean:
	@rm -fv {csv,sexpress}.{c,s,o,png} test-* test.o
