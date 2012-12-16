
RAGEL_OPTS=-s -m -G2
CFLAGS=-Wall -pedantic -O2

.SUFFIXES: %.s
.PRECIOUS: %.c

all: csv.png csv.s test

test: test.o csv.o
	$(CC) $(CFLAGS) -o $@ $^

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
	@rm -fv csv.{c,s,o,png} test test.o
