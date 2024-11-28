#include <stdio.h>
#include "asm6.h"

int main(void){
	
	// Variáveis e Pointers
	char sensor[100] = "sensor_id:8#type:atmospheric_temperature#value:21.60#unit:celsius#time:2470030";
	char* inputPtr = sensor;

	char tokenSensorId[15] ="sensor_id:";
	char* idPtr = tokenSensorId;

	char tokenType[15] ="type:";
	char* typePtr = tokenType;
	
	char tokenValue[15] ="value:";
	char* valuePtr = tokenValue;
	
	char tokenUnit[15] ="unit:";
	char* unitPtr = tokenUnit;
	
	char tokenTime[15] ="time:";
	char* timePtr = tokenTime;
	
	int output = 0;
	int* outputPtr = &output;
	
	int retrivedStatus = 0;

	// Extração da Informação e Impressão do Output
	printf("\n###### Informação do Sensor ######\n");
	printf("%s\n", sensor);

	printf("\n###### Tokens ######");
	
	// Sensor_id
	retrivedStatus = extract_token(inputPtr, idPtr, outputPtr);
	printRetrievedInfo(tokenSensorId, retrivedStatus, output);
	
	// Type
	retrivedStatus = extract_token(inputPtr, typePtr, outputPtr);
	printRetrievedInfo(tokenType, retrivedStatus, output);
	
	// Value
	retrivedStatus = extract_token(inputPtr, valuePtr, outputPtr);
	printRetrievedInfo(tokenValue, retrivedStatus, output);
	
	// Unit
	retrivedStatus = extract_token(inputPtr, unitPtr, outputPtr);
	printRetrievedInfo(tokenUnit, retrivedStatus, output);
	
	//Timestamp
	retrivedStatus = extract_token(inputPtr, timePtr, outputPtr);
	printRetrievedInfo(tokenTime, retrivedStatus, output);

return 0;
}
