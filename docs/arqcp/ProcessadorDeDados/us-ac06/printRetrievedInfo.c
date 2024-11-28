#include <stdio.h>

void printRetrievedInfo(char token[], int retrivedStatus, int output) {
	printf("\nEstado da extração da Informação: %d\n", retrivedStatus);
	if (retrivedStatus != 0){
		printf("%s %d\n", token, output);
	} else {
	printf("%s Este valor não pode ser extraido.\n", token);
	}
}
