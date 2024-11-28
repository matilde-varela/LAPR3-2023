#include <stdio.h>
#include <string.h>
#include "function.h"
#include <dirent.h>

int main() {
   FILE *outputFile;

	alocateSaidaDeDados("output");

	SaidaDeDados *ptr = allocSaidaDeDados();

	if ((outputFile = fopen("output/Output.txt", "w")) == NULL) {
            printf("Error - Unable to create %s\n", "Output.txt");
            return 1; // Return an error code to indicate failure
    }

	char diretorio[50] = "../Projeto/intermedio";

    	DIR *directory = opendir(diretorio);

    	if (directory == NULL){
    		printf("Erro a abrir o diretório.");
    		return 1;
    	}
    	
    	struct dirent *entry;
    	while((entry = readdir(directory)) != NULL){
    		FILE *inputFile;
    		char buffer[100];
    		char temp[500];
    		snprintf(temp, sizeof(temp), "%s/%s", diretorio, entry->d_name);
    		if ((inputFile = fopen(temp, "r")) != NULL) {
                while (fgets(buffer, sizeof(buffer), inputFile) != NULL) {
					float temp = 0;
                    char *token = strtok(buffer, ",");
                    ptr->sensor_id = *token;
  
					token = strtok(NULL, ",");
					sscanf(token, "%f", &temp);
					temp=temp/100;
					ptr->write_counter = temp;
					
					
					token = strtok(NULL, ",");
					int i = 0;
					while(*token != '\0'){
						ptr->type[i] = *token;
						token++;
						i++;
					}
					i++;
					ptr->type[i] = *token;
					
					
					token = strtok(NULL, ",");
					i = 0;
					while(*token != '\0'){
						ptr->unit[i] = *token;
						token++;
						i++;
					}
					i++;
					ptr->unit[i] = *token;
					
					token = strtok(NULL, ",");
					sscanf(token, "%f", &temp);
					temp=temp/100;
					ptr->mediana = temp;
					ptr = reallocSaidaDeDados(ptr);
    			}
    			fclose(inputFile);
    		}
    		fprintf(outputFile, "|Sensor: %d | Write: %d | Type: %s | Unit: %s | Value: %d|\n", ptr->sensor_id,  ptr->write_counter,  ptr->type,  ptr->unit,  ptr->mediana);

    	}
    	closedir(directory);
	
	fclose(outputFile);

    return 0;
}
