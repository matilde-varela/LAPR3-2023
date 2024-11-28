#include <stdio.h>
#include <unistd.h>
#include "functions.h"
#include <string.h>
#include <stdlib.h>
#include <time.h>

int main() {
	clock_t startClock = clock();
	//conversao para milisegundos
	double inseconds = (double) startClock / CLOCKS_PER_SEC;
	int elapsedMilliseconds = (int) ((((long double) startClock / CLOCKS_PER_SEC) * 1000.0) * 1000000);
	int picoFirstTime = 0;
	int* timePico = &picoFirstTime;
	char *token = "time:";
	int offset_time = -1;
	
	int d = 15;
	int counter = 0;
	int *ptr_counter = &counter;
	
	// ---> Aloca memória para o vetor de sensores.
	Sensor **sensor_array = allocVetorSensores();
	Sensor ***ptr_sensor;
	ptr_sensor = &sensor_array;
	
	// ---> Variável do tamanho do array - varia dependendo das realocações.
	int array_size = ARRAY_SENSOR_SIZE;
	int *ptr_arr_size = &array_size;
	
	// ---> Nome do ficheiro de leitura - será obtido através US AC07 (se nao estou em erro) por isso MUDAR 
	char filename[80] = "test.txt";
	
    FILE *inputFile; 
    
    // ---> Ficheiro de escrita da informação contida nas estruturas dos sensores.
    FILE *outputFile;
    
	// ---> Abre ficheiro de leitura de dados.
	if((inputFile = fopen( filename, "r" )) == NULL) {
		printf("Error- Unable to open %s\n", filename );
	}
	
	// ---> Ciclo de leitura-extração-inserção de dados	
	while(counter != d){
		char readString[100];
		char *ptr_read;
		ptr_read = readString;
		
		// ---> Obtém uma linha de dados do ficheiro
		fgets(ptr_read, 100, inputFile);	
			
		
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
			
			// ---> Irá extrair os dados da linha e, de seguida, inseri-los na estrutura de dados.
			insert_data_line(ptr_read, ptr_sensor,ptr_arr_size,ptr_counter);
			
			// ---> Incrementa o número de leituras
			counter++;		
		}		
		
	}
	// ---> Fecha o ficheiro.
	fclose(inputFile);
	
//---------------------------------------------------------------------------------------
	
	// ---> Obtenção do nome do ficheiro de output ("AAAAMMDDHHMMSS_sensors.txt").
	char* returnedOutputFilename = get_outputFileName();

		// ---> Abre ficheiro de leitura de dados.
	if(returnedOutputFilename == NULL) {
		printf("Error- Unable to obtain new output file name.\n");
	}

    // ---> Determina o comprimento da string de retorno.
    int length = strlen(returnedOutputFilename);

    // ---> Declaração de uma string para armazenar o apontado da string retornada, adiciona-se 1 para o null terminator.
    char outputFilename[length + 1];

    // ---> Copia o conteúdo da string de retorno para a nova string.
    strcpy(outputFilename, returnedOutputFilename);
    
	// ---> Liberta a memória alocada para o nome do ficheiro output.
    free(returnedOutputFilename);
    
    // ---> Verifica se consegue abrir o ficheiro para "append" (acrescenta ao conteudo já existente no ficheiro).
    if((outputFile = fopen(outputFilename, "a" )) == NULL) {
		printf("Error - Unable to open %s\n", outputFilename);
	}
	
//---------------------------------------------------------------------------------------

	// ---> Para cada sensor, calcular a mediana e serializar a informação.
	for (int i = 0; i < ARRAY_SENSOR_SIZE; ++i){
		Sensor *sensor = sensor_array[i];
		int *vec = sensor->arrayMedias;

	// Definir tamanho do vetor de medianas, por agora está 4, só para testar
	// ---> Cálculo da mediana do sensor.
		int medianaSensor = mediana(vec, 4);
		
	// ---> Serialização e insersão da informação no ficheiro de output, se o valor de offset for válido.
		if (offset_time > 0){
			//Tempo (em clock ticks) do instante do tempo de execucao do programa
			clock_t instantClock = clock();
			//conversao para milisegundos
			int instanteAtualMilissegundos = (int) ((((long double) instantClock / CLOCKS_PER_SEC) * 1000.0) * 1000000);
			serialize_info(sensor, medianaSensor, outputFile, offset_time, instanteAtualMilissegundos);
		}else{
			printf("O valor de offset (diferença de tempo entre o programa e o Raspberry) é inválido.\n");
		}
	}
	
	// ---> Fecha o ficheiro.
	fclose(outputFile);

  return 0;
}
