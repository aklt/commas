RAGEL_OPTS=-s -m -G2
CFLAGS=-Wall -pedantic -O2

.PRECIOUS: %.c

all: test

test: test.o csv.o
	$(CC) $(CFLAGS) -o $@ $^

%: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.c: %.rl
	ragel $(RAGEL_OPTS) $<

clean:
	@rm -fv csv.{c,o} test test.o
