#include <stdio.h>
#include "asm1.h"

void initializeOutput(int* ptr, int size);

int main(void){
	
	char sensor[100] = "sensor_id:8#type:atmospheric_temperature#value:21.60#unit:celsius#time:2470030";
	char* inputPtr = sensor;
	int output = -1;
	int* outputPtr = &output;
	
	printf("###### Informação do Sensor ######\n");
	printf("%s\n", sensor);

	printf("\n###### Tokens ######\n");
	
	char token1[15] = "sensor_id:";
	char* tokenPtr1 = token1;

	extract_token(inputPtr, tokenPtr1, outputPtr);

	printf("%s ", token1);
		if(*(outputPtr) != -1){
			printf("%d", *(outputPtr));
		}else{
			printf("Este valor não pode ser extraido.");
		}
	printf("\n");

	//////////////////////////////////

	char token2[15] = "type:";
	char* tokenPtr2 = token2;
	output = -1;
	extract_token(inputPtr, tokenPtr2, outputPtr);

	printf("%s : ", token2);
		if(*(outputPtr) != -1){
			printf("%d", *(outputPtr));
		}else{
			printf("Este valor não pode ser extraido.");
		}
	printf("\n");

	////////////////////////////////////

	char token3[15] = "value:";
	char* tokenPtr3 = token3;
	output = -1;
	extract_token(inputPtr, tokenPtr3, outputPtr);

	printf("%s : ", token3);
		if(*(outputPtr) != -1){
			printf("%d", *(outputPtr));
		}else{
			printf("Este valor não pode ser extraido.");
		}
	printf("\n");

	////////////////////////////////////

	char token4[15] = "unit:";
	char* tokenPtr4 = token4;
	output = -1;

	extract_token(inputPtr, tokenPtr4, outputPtr);

	printf("%s : ", token4);
		if(*(outputPtr) != -1){
			printf("%d", *(outputPtr));
		}else{
			printf("Este valor não pode ser extraido.");
		}
	printf("\n");

	//////////////////////////////////////

	char token5[15] = "time:";
	char* tokenPtr5 = token5;
	output = -1;
	extract_token(inputPtr, tokenPtr5, outputPtr);

	printf("%s : ", token5);
		if(*(outputPtr) != -1){
			printf("%d", *(outputPtr));
		}else{
			printf("Este valor não pode ser extraido.");
		}
	printf("\n");

return 0;
}