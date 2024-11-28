#include <stdio.h>
#include <unistd.h>
#include "functions.h"
#include <string.h>

int main() {  
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
			// ---> Irá extrair os dados da linha e, de seguida, inseri-los na estrutura de dados.
			insert_data_line(ptr_read, ptr_sensor,ptr_arr_size,ptr_counter);
			
			// ---> Incrementa o número de leituras
			counter++;		
		}		
		
	}
	// ---> Fecha o ficheiro.
	fclose(inputFile);
  
  return 0;
}
