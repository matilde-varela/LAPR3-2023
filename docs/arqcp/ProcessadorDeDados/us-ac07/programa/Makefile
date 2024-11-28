processadordedados: main.o struct_allocation.o
		gcc main.o struct_allocation.o -z noexecstack -o processadordedados
		
main.o: main.c
		gcc -g -Wall -Wextra -fanalyzer -c main.c -o main.o
		
struct_allocation.o: struct_allocation.c
		gcc -g -Wall -Wextra -fanalyzer -c struct_allocation.c -o struct_allocation.o
			
run: processadordedados
		./processadordedados /dev/ttyS0 config intermedio 15
		
vg: processadordedados
	valgrind ./processadordedados /dev/ttyS0 config intermedio 15
		
clean:
		rm  -f *.o processadordedados
