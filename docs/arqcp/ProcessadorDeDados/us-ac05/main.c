#include <stdio.h>
#include "mediana.h"


int main(void){
	int vecPar[] = {9,16,4,3,2,19};
	int* ptrPar = vecPar;
	int numPar = 6;
	int res = 0;
	
	res = mediana(ptrPar,numPar);
	
	printf("--[ PAR ]--\n");
	printf("MEDIANA:%d\n",res);
	
	for ( int i = 0; i < numPar; i++){
		printf("arr[%d]: %d\n",i,vecPar[i]);
	}
	/*------------------------------------*/
	int vecImpar[] = {7,13,4,16,0};
	int* ptrImpar = vecImpar;
	int numImpar = 5;
	
	res = mediana(ptrImpar,numImpar);


	printf("--[ ÍMPAR ]--\n");
	printf("MEDIANA:%d\n",res);
	
	for ( int i = 0; i < numImpar; i++){
		printf("arr[%d]: %d\n",i,vecImpar[i]);
	}

	return 0;
}
