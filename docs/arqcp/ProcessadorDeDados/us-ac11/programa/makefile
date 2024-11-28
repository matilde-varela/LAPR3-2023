prog: main.o extract_token.o struct_allocation.o extract_string.o data_insertion.o enqueue_value.o get_outputFileName.o mediana.o sort_array.o serialize_info.o
	gcc main.o extract_token.o struct_allocation.o extract_string.o data_insertion.o enqueue_value.o get_outputFileName.o mediana.o sort_array.o serialize_info.o -z noexecstack -o prog

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
	
get_outputFileName.o: get_outputFileName.c
	gcc -g -Wall -Wextra -fanalyzer -c get_outputFileName.c -o get_outputFileName.o

mediana.o: mediana.s 
	gcc -g -Wall -Wextra -fanalyzer -c mediana.s -o mediana.o

sort_array.o: sort_array.s 
	gcc -g -Wall -Wextra -fanalyzer -c sort_array.s -o sort_array.o

serialize_info.o: serialize_info.c
	gcc -g -Wall -Wextra -fanalyzer -c serialize_info.c -o serialize_info.o

vg: prog
	valgrind ./prog /etc/ttyS0 config intermedio 15

run: prog
	./prog /etc/ttyS0 config intermedio 15

clean:
	rm -f *.o prog
