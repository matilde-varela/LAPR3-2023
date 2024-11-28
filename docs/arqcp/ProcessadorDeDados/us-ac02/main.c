#include <stdio.h>
#include "asm.h"

int main(void){
	
	int array1[3]={0,0,0};
	
	int pos1=0, pos6=0;

	int* read1 =  &pos1;
	
	int* write1 =  &pos6;
	
	int* ptr1 = array1;
	
	int length = 3;
	
	enqueue_value(ptr1, length, read1, write1, 5);
	
	printf("Array1:\n");
	for(int i = 0; i < length; i++){
		printf("%d ", array1[i]);
	}
	printf("\n");
	printf("Read: %d | Write: %d\n", *read1, *write1);
	
   return 0;
}

