usac01: asm1.o main.o
	gcc asm1.o main.o -z noexecstack -o usac01
		
main.o: main.c asm1.h
	gcc -g -Wall -Wextra -fanalyzer -c main.c -o main.o
		
asm1.o: asm1.s
	gcc -g -Wall -Wextra -fanalyzer -c asm1.s -o asm1.o
		
clean:
	rm -f *.o usac01

run: usac01
	./usac01