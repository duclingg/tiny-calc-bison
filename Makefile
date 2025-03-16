CC = gcc
CFLAGS = -g
LIBS = -lm

# Main target
all: tiny-calc

# Generate parser
tiny-calc.c: tiny-calc.y
	yacc -d tiny-calc.y
	mv y.tab.c tiny-calc.c
	mv y.tab.h tiny-calc.h

# Generate scanner
lex.yy.c: tiny-calc.l tiny-calc.h
	flex tiny-calc.l

# Compile the calculator
tiny-calc: tiny-calc.c lex.yy.c
	$(CC) $(CFLAGS) -o tiny-calc tiny-calc.c lex.yy.c $(LIBS)

# Clean up generated files
clean:
	rm -f tiny-calc tiny-calc.c tiny-calc.h lex.yy.c *.o *~

# Run the calculator
run: tiny-calc
	./tiny-calc

.PHONY: all clean run