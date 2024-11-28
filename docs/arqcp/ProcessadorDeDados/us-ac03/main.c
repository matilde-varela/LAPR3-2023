#include <stdio.h>
#include "asm.h"

int main(void) {
	int original_array[] = {1,2,3,4,5,6,7,8,9,10};
	int *array = original_array;
	int length = 10;
	int num = 6;
	int new_array[num];
	
	int pos1 = 7;
	int pos2 = 3;
	int *read = &pos1;
	int *write = &pos2;
	int *vec = new_array;
	
	printf("The buffer is:" );
	for(int i = 0; i < length; i++){
			printf("%d ", original_array[i]);
		} 
	printf("\n");	
	
	printf("The original value for read is: %d\n", pos1);
	printf("The original value for write is: %d\n\n", pos2);
	
	int result = move_num_vec(array, length, read, write, num, vec);
	
		
	
	if(result == 1){
		printf("The array was copied successfully to a new array with the size %d.\nThe new array is: ", num);
		for(int i = 0; i < num; i++){
			printf("%d ", new_array[i]);
		}
		printf("\n");	
		
		printf("The new value for read is: %d\n", pos1);
		printf("The new value for write is: %d\n", pos2);
	
		printf("\n");	
	} else{
		printf("The array wasn't copied. Not enough elements in the original array.\n\n");
	}                                                                                                                                      

	return 0;
}
