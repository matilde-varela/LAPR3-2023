usac06: asm6.o printRetrievedInfo.o main.o
	gcc asm6.o printRetrievedInfo.o main.o -z noexecstack -o usac06
		
main.o: main.c asm6.h
	gcc -g -Wall -Wextra -fanalyzer -c main.c -o main.o
		
asm6.o: asm6.s
	gcc -g -Wall -Wextra -fanalyzer -c asm6.s -o asm6.o
	
printRetrievedInfo.o: printRetrievedInfo.c
	gcc -g -Wall -Wextra -fanalyzer -c printRetrievedInfo.c -o printRetrievedInfo.o
		
clean:
	rm -f *.o usac06

run: usac06
	./usac06
