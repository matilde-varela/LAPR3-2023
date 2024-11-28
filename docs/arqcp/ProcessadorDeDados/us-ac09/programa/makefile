prog: main.o extract_token.o struct_allocation.o extract_string.o data_insertion.o enqueue_value.o
	gcc main.o extract_token.o struct_allocation.o extract_string.o data_insertion.o enqueue_value.o -z noexecstack -o prog

main.o: main.c functions.h
	gcc -g -Wall -Wextra -fanalyzer -c main.c -o main.o
		
extract_token.o: extract_token.s
	gcc -g -Wall -Wextra -fanalyzer -c extract_token.s -o extract_token.o

struct_allocation.o: struct_allocation.c
	gcc -g -Wall -Wextra -fanalyzer -c struct_allocation.c -o struct_allocation.o

extract_string.o: extract_string.c
	gcc -g -Wall -Wextra -fanalyzer -c extract_string.c -o extract_string.o
	
data_insertion.o: data_insertion.c
	gcc -g -Wall -Wextra -fanalyzer -c data_insertion.c -o data_insertion.o
	
enqueue_value.o: enqueue_value.s
	gcc -g -Wall -Wextra -fanalyzer -c enqueue_value.s -o enqueue_value.o

vg: prog
	valgrind ./prog

run: prog
	./prog

clean:
	rm -f *.o prog
