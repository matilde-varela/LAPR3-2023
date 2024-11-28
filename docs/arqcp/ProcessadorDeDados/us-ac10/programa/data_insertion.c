#include "functions.h"
#include <stdio.h>
#include <string.h>

/*
 * Imprime os dados de uma estrutura de sensor.
 */
void print_sensor_data(Sensor **sensor_array, int pos){
	printf("\n--INFO SENSOR----------\n");
	printf("Sensor ID: %d\n", sensor_array[pos]->sensor_id);
	printf("Type: %s\n", sensor_array[pos]->type);
	printf("Unit: %s\n", sensor_array[pos]->unit);
	printf("Tempo: %d\n", sensor_array[pos]->instanteTemporal);
	printf("Write counter: %d\n", sensor_array[pos]->write_counter);
	printf("Buffer: \n");
	int i = 0;
	for(; i < NUM; i++){
		printf("arr[%d]: %d\n", i, sensor_array[pos]->buffer->array[i]);
	}	
	printf("-----------------------\n\n");
}

/*
 * Verifica se sensor já se encontra no vetor de sensores na memória.
 * Retorna {1} se encontrou um sensor com o id indicado, {0} caso contrário.
 */
char check_array_has_sensor(Sensor** sensor_array, int sensor_id, int array_size) {
    int i = 0;
    char found = 0;

    while ((i < array_size) && (sensor_array[i] != NULL)) {
        if (sensor_array[i]->sensor_id == sensor_id) {
            found = 1;
            break;
        }
        i++;
    }

    return found;
}

/*
 * Verifica se o array de sensores tem espaço disponível para o novo sensor.
 * 	Retorna {-1} caso o vetor não tenha espaço, caso contrário retorna o valor da primeira posição vazia.
 */
int check_array_has_space(Sensor **sensor_array, int array_size) {
    int i = 0;
    int empty = -1; 

    for (; i < array_size; i++) {
        if (sensor_array[i] == NULL) {
            empty = i;
            break;
        }
    }   
    return empty;
}

/*
 * Cria um novo sensor.
 * Primeiro extrai os dados (type, unit, value, time) da linha de dados. De seguida, prossegue à inserção dos dados na struct.
 * Retorna um sensor, ou seja uma struct sensor. 
 */
Sensor *create_sensor(char *ptr_read, int counter, int sensor_id){
	char* token_ptr;
	
	Sensor *sensor = allocSensor(NUM,NUM);
	sensor->sensor_id = sensor_id;	
	sensor->write_counter = counter;
	sensor->timeOut = TIME_OUT;

	token_ptr = "type:";
	extract_string(ptr_read,token_ptr,5, sensor->type);
	
	token_ptr = "unit:";
	extract_string(ptr_read, token_ptr,5, sensor->unit);

	token_ptr =  "time:";
	extract_token(ptr_read, token_ptr, &sensor->instanteTemporal);
	
	int value;
	int* ptr_value = &value;
	token_ptr = "value:";
	extract_token(ptr_read, token_ptr, ptr_value);
	
	enqueue_value(sensor->buffer->array , sensor->buffer->size, &(sensor->buffer->read), &(sensor->buffer->write), value);				

	return sensor;	
}

/*
 * Insere dados em um sensor existente.
 * Primeiro extrai os dados em falta(value, time) da linha de dados. De seguida, prossegue à inserção destes no sensor situado no vetor de sensores.. 
 */
void insert_data_sensor(Sensor **sensor_array, char *ptr_read, int counter, int sensor_id, int array_size){
	char* token_ptr;
	
	int value;
	int* ptr_value = &value;
	token_ptr = "value:";
	extract_token(ptr_read, token_ptr, ptr_value);

	int time;
	int* ptr_time = &time;
	token_ptr =  "time:";
	extract_token(ptr_read, token_ptr, ptr_time);
	
	int i = 0;
	for (; i < array_size; i++) {
		if (sensor_array[i]->sensor_id == sensor_id) {
			sensor_array[i]->write_counter = counter;			
			sensor_array[i]->instanteTemporal = time;						
			enqueue_value(sensor_array[i]->buffer->array , sensor_array[i]->buffer->size, &(sensor_array[i]->buffer->read), &(sensor_array[i]->buffer->write), value);														
			
			print_sensor_data(sensor_array, i);
			break;
		}
	}	
}

/*
 * Extrai os dados de uma linha do ficheiro e, de seguida, insere-os na estrutura de dados.
 */
void insert_data_line(char *ptr_read, Sensor ***sensor_array, int *array_size, int *counter){
	int result;
	remove_newline(ptr_read); // ---> Remove o \n no final da linha.
	
	if(*sensor_array != NULL){
		int sensor_id;
		int* ptr_sensorId = &sensor_id;
		char token[15] = "sensor_id:";
		char* token_ptr = token;

		result = extract_token(ptr_read, token_ptr, ptr_sensorId);
		
		if (result == 1) {
			int has_sensor = check_array_has_sensor((*sensor_array), sensor_id,*array_size); // ---> Verifica se sensor já se encontra no vetor de sensores na memória.

			if (has_sensor == 1){
				printf("AVISO: Sensor %d encontrado - a inserir dados.\n",sensor_id);	
				insert_data_sensor((*sensor_array),ptr_read,*counter,sensor_id, *array_size);
			} else {
				printf("AVISO: Sensor %d não encontrado - a criar e inserir dados.\n",sensor_id);
				Sensor *sensor = create_sensor(ptr_read, *counter, sensor_id); // ---> Cria um novo sensor.
				int pos = check_array_has_space((*sensor_array), *array_size); // ---> Verifica se o array de sensores tem espaço disponível para o novo sensor.
				
				// ---> Caso o array não tenha espaço, este vai ser realocado, ou seja, irá ser reservado espaço na memória para mais uma posição/sensor no array.
				if (pos == -1) {
					printf("AVISO: A realocar o vetor de sensores.\n");
					(*sensor_array)  = reallocVectorSensores(sensor_array, (*array_size + 1), *array_size);
					pos = *array_size; 
					(*array_size)++;
				}
				(*sensor_array)[pos] = sensor; // ---> Inserção do novo sensor no array de sensores.
				print_sensor_data((*sensor_array), pos); // ---> Imprime os dados do sensor.
			}					
		} else {
			printf("ERRO: Não foi possível obter o id do sensor. \n");
		}			
	} else {
		printf("ERRO: Falha na alocação do vetor de sensores.\n");
	}
}

