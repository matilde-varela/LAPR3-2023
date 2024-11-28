prog_mediana: main.o mediana.o sort_array.o
	gcc main.o mediana.o sort_array.o -z noexecstack -o prog_mediana

main.o: main.c mediana.h
	gcc -g -Wall -Wextra -fanalyzer -c main.c -o main.o

mediana.o: mediana.s 
	gcc -g -Wall -Wextra -fanalyzer -c mediana.s -o mediana.o

sort_array.o: sort_array.s 
	gcc -g -Wall -Wextra -fanalyzer -c sort_array.s -o sort_array.o

run: prog_mediana
	./prog_mediana

valgrind: prog_mediana
	valgrind ./prog_mediana

clean:
	rm -f *.o prog_mediana
