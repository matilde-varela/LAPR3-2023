prog: main.o asm.o
		gcc main.o asm.o -z noexecstack -o prog
		
main.o: main.c asm.h
		gcc -g -Wall -Wextra -fanalyzer -c main.c -o main.o
		
asm.o: asm.s
		gcc -g -Wall -Wextra -fanalyzer -c asm.s -o asm.o
		
run: prog
		./prog
		
clean:
		rm  -f *.o prog
