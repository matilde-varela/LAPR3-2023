#include "functions.h"
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdlib.h>

/*
 * Obtenção do nome do ficheiro AAAAMMDDHHMMSS sensors.txt, onde AAAA é o ano,
 * MM o número do mês, DD o dia, HH a hora, MM os minutos e SS os segundos.
*/
char* get_outputFileName(){
	// Tipo de dados que representa tempo num formato numerico
	time_t currentTime;
	//Estrutura que contem o tempo distribuido pelos elementos do calendário (mês, ano, dia, hora, etc...)
    struct tm *localTime;
    //Nome do ficheiro
    char *filename = malloc(50); // Alocaçao de memoria para a string do nome do ficheiro

    if (filename == NULL) {
        // Se não for possivel alocar memoria, retorna-se null
        return NULL;
    }

	//Tempo (no calendario, com segundos)
    currentTime = time(NULL);
    //Adaptação de currentTime numa estrutura
    localTime = localtime(&currentTime);

    int year = localTime->tm_year + 1900; // anos desde 1900
    int month = localTime->tm_mon + 1;    // meses são de 0-11 (então temos de adicionar 1)
    int day = localTime->tm_mday;         // dia do mês (1-31)
    int hour = localTime->tm_hour;        // hora (0-23)
    int minute = localTime->tm_min;       // minutos (0-59)
    int second = localTime->tm_sec;       // segundos (0-59)
    
    // Formatação do nome do ficheiro
    sprintf(filename, "%04d%02d%02d%02d%02d%02d_sensors.txt", year, month, day, hour, minute, second);
    
    return filename;
}
