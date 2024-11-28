SaidaDeDados: main.o struct_allocation.o
		gcc main.o struct_allocation.o -z noexecstack -o SaidaDeDados
		
main.o: main.c function.h
		gcc -g -Wall -Wextra -fanalyzer -c main.c -o main.o
		
struct_allocation.o: struct_allocation.c
		gcc -g -Wall -Wextra -fanalyzer -c struct_allocation.c -o struct_allocation.o
			
run: SaidaDeDados
		./SaidaDeDados 
		
clean:
		rm  -f *.o SaidaDeDados


