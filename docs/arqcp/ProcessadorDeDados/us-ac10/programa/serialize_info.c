#include "functions.h"
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdlib.h>

/*
* Avalia se o sensor em questão está numa situação de erro ou não
*/
int isSensorInError(Sensor *sensorPtr, int offset_time, int instanteAtualMilissegundos){

	instanteAtualMilissegundos -= offset_time;
	
	//Se a diferença entre o instante da ultima leitura do sensor e o instante atual for superior ao timeout
	//entao retorna 1, caso contrario 0
	 if((sensorPtr->instanteTemporal - instanteAtualMilissegundos) > (int) sensorPtr->timeOut){
		 return 1;
	 }
	return 0;
}


/*
 * Serializa a informação contida num sensor com a adição da mediana para um ficheiro
*/
void serialize_info(Sensor *sensorPtr, int mediana, FILE *outputFile, int offset_time, int instanteAtualMilissegundos){
	char *line = malloc(100); // Alocar memória para a nova linha a escrever no ficheiro

    if (line == NULL) {
        //Caso não seja possivel alocar memória - informar
        printf("Não foi possível alocar memória para a nova linha do ficheiro.\n");
        return;
    }
    
    if (mediana >= 0 && offset_time >= 0){
		//---> Detetar possível situação de erro
		//Obtenção do instante atual (timestamp)
		int isError = isSensorInError(sensorPtr, offset_time, instanteAtualMilissegundos);
		
		//sensor_id,write_counter,type,unit,mediana#
		if(isError == 1){
			sprintf(line, "%d,%hd,%s,%s,error#", sensorPtr->sensor_id, sensorPtr->write_counter, sensorPtr->type, sensorPtr->unit);	
		}else{
			sprintf(line, "%d,%hd,%s,%s,%d#", sensorPtr->sensor_id, sensorPtr->write_counter, sensorPtr->type, sensorPtr->unit, mediana);
		}
		
		//Escrever no ficheiro output a linha construida
		fprintf(outputFile,"%s\n", line);
	}
	
	//Libertar os recursos da memória, ocupados pela linha
	free(line);
}
