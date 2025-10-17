# This demonstrates the PROBLEM - library always rebuilds
.PHONY: all
all: Release

.PHONY: Release
Release: obj/main.o obj/utils.o
	ar rcs lib/libtest.a obj/main.o obj/utils.o
	@echo "Built library"

obj/main.o: src/main.c
	@mkdir -p obj
	gcc -c src/main.c -o obj/main.o

obj/utils.o: src/utils.c
	@mkdir -p obj
	gcc -c src/utils.c -o obj/utils.o

clean:
	rm -rf obj lib
