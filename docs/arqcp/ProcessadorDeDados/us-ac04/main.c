#include <stdio.h>
#include "sort_array.h"


int main(void){
	int vec[] = {14,0,1,5,10};
	int* ptr = vec;
	int num = 5;
	
	sort_array(ptr,num);

	printf("RESULTADO:\n");
	
	for ( int i = 0; i < num; i++){
		printf("arr[%d]: %d\n",i,vec[i]);
	}

	return 0;
}
