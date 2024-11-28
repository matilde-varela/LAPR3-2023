prog_sort_array: main.o sort_array.o
	gcc main.o sort_array.o -z noexecstack -o prog_sort_array

main.o: main.c sort_array.h
	gcc -g -Wall -Wextra -fanalyzer -c main.c -o main.o

sort_array.o: sort_array.s
	gcc -g -Wall -Wextra -fanalyzer -c sort_array.s -o sort_array.o

run: prog_sort_array
	./prog_sort_array

valgrind: prog_sort_array
	valgrind ./prog_sort_array

clean:
	rm -f *.o prog_sort_array
