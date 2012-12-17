
RAGEL_OPTS=-s -m -G2
CFLAGS=-Wall -pedantic -O2

.SUFFIXES: %.s
.PRECIOUS: %.c

all: sexpress.png sexpress.s test

test: test.o sexpress.o
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
	@rm -fv sexpress.{c,s,o,png} test test.o
