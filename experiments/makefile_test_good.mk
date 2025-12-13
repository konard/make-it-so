# This demonstrates the SOLUTION - library only rebuilds when needed
.PHONY: all
all: Release

.PHONY: Release
Release: lib/libtest.a
	@echo "Built library"

lib/libtest.a: obj/main.o obj/utils.o
	@mkdir -p lib
	ar rcs lib/libtest.a obj/main.o obj/utils.o

obj/main.o: src/main.c
	@mkdir -p obj
	gcc -c src/main.c -o obj/main.o

obj/utils.o: src/utils.c
	@mkdir -p obj
	gcc -c src/utils.c -o obj/utils.o

clean:
	rm -rf obj lib
