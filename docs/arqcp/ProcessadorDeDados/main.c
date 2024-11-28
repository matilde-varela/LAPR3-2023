#include <stdio.h>
#include <unistd.h>
#include "functions.h"
#include <string.h>
#include <stdlib.h>
#include <time.h>

int main(int argc,char *argv[]) {
	clock_t startClock = clock();
	
	// ---> Criação do diretório
	char filename[80];		// ---> Nome do ficheiro de leitura
	char b[20];
	char c[20];
	int d = -1;
	char directorio[12] = "intermedio/";

	sscanf(argv[1], "%s", filename);
	sscanf(argv[2], "%s", b);
	sscanf(argv[3], "%s", c);
	sscanf(argv[4], "%d", &d);

	printf("Separação dos conteúdos passados pelo main:\n");
	for(int i = 1; i < argc; i++){
		printf("\nargv[%d]: %s", i, argv[i]);
	}
	printf("\n");

	alocateProcessadorDeDados(c);

	printf("\n");

	// ---> Conversao para milisegundos
	double inseconds = (double) startClock / CLOCKS_PER_SEC;
	int elapsedMilliseconds = (int) ((((long double) startClock / CLOCKS_PER_SEC) * 1000.0) * 1000000);
	int picoFirstTime = 0;
	int* timePico = &picoFirstTime;
	char *token = "time:";
	int offset_time = -1;
	
	Sensor **sensor_array = allocVetorSensores();		// ---> Aloca memória para o vetor de sensores.
	Sensor ***ptr_sensor;
	ptr_sensor = &sensor_array;
	int array_size = ARRAY_SENSOR_SIZE;		// ---> Variável do tamanho do array - varia dependendo das realocações.
	int *ptr_arr_size = &array_size;
	
    FILE *inputFile;
    FILE *outputFile;		 // ---> Ficheiro de escrita da informação contida nas estruturas dos sensores.
    
		
	if((inputFile = fopen( filename, "r" )) == NULL) {		 // ---> Ficheiro de escrita da informação contida nas estruturas dos sensores.
		printf("Error- Unable to open %s\n", filename );
	}
    
	while(1) {
		int counter = 0;
		int *ptr_counter = &counter;
		
		
		while(counter != d){		// ---> Ciclo de leitura-extração-inserção de dados
			char readString[100];
			char *ptr_read;
			ptr_read = readString;

			fgets(ptr_read, 100, inputFile);		// ---> Obtém uma linha de dados do ficheiro
			
			if (*ptr_read != '\n') {
				if (counter == 0) {
					remove_newline(ptr_read);
					extract_token(ptr_read,token,timePico);
					if (picoFirstTime > 0 && elapsedMilliseconds > 0){
						printf("Time retrieved - Pi Pico: %d\n", picoFirstTime);
						printf("Time retrieved seconds - (start - virtual machine): %f\n", inseconds);
						printf("Time retrieved - (start - virtual machine): %d\n", elapsedMilliseconds);
						offset_time = elapsedMilliseconds - picoFirstTime;
						printf("offset value: %d\n", offset_time);
					}
				}
				insert_data_line(ptr_read, ptr_sensor,ptr_arr_size,ptr_counter);		// ---> Irá extrair os dados da linha e, de seguida, inseri-los na estrutura de dados.
				counter++;		// ---> Incrementa o número de leituras
			}
		}

//---------------------------------------------------------------------------------------
		char* returnedOutputFilename = get_outputFileName();		// ---> Obtenção do nome do ficheiro de output ("AAAAMMDDHHMMSS_sensors.txt").

		if(returnedOutputFilename == NULL) {						// ---> Abre ficheiro de leitura de dados.
			printf("Error- Unable to obtain new output file name.\n");
		}
		
		int length = strlen(returnedOutputFilename);				// ---> Determina o comprimento da string de retorno.

		char outputFilename[length + 1];							// ---> Declaração de uma string para armazenar o apontado da string retornada, adiciona-se 1 para o null terminator.

		strcpy(outputFilename, returnedOutputFilename);				// ---> Copia o conteúdo da string de retorno para a nova string.

		free(returnedOutputFilename);								// ---> Liberta a memória alocada para o nome do ficheiro output.

		strcat(directorio, outputFilename);
		
		if((outputFile = fopen(directorio, "a" )) == NULL) {		// ---> Verifica se consegue abrir o ficheiro para "append" (acrescenta ao conteudo já existente no ficheiro).
			printf("Error - Unable to open %s\n", outputFilename);
		}

//---------------------------------------------------------------------------------------

		// ---> Para cada sensor, calcular a mediana e serializar a informação.
		for (int i = 0; i < array_size; ++i){
			move_num_vec(sensor_array[i]->buffer->array, sensor_array[i]->buffer->size, &sensor_array[i]->buffer->read, &sensor_array[i]->buffer->write,NUM, sensor_array[i]->arrayMedias);		// ---> Passa os valores do buffer para arrayMedias
			sort_array(sensor_array[i]->arrayMedias, NUM);		// ---> Ordena os elementos do arrayMedias		
			int medianaSensor = mediana(sensor_array[i]->arrayMedias, NUM);			// ---> Cálculo da mediana do sensor.
			
			// ---> Serialização e insersão da informação no ficheiro de output, se o valor de offset for válido.
			if (offset_time >= 0){
				int execucaoMilissegundos = (int) ((((long double) startClock / CLOCKS_PER_SEC) * 1000.0) * 1000000);
				serialize_info(sensor_array[i], medianaSensor, outputFile, offset_time, execucaoMilissegundos);
			} else {
				printf("O valor de offset (diferença de tempo entre o programa e o Raspberry) é inválido.\n");
			}
		}
	}
	fclose(outputFile); 	// ---> Fecha o ficheiro.
	fclose(inputFile);

	freeVectorSensores(sensor_array,array_size);

  return 0;
}
