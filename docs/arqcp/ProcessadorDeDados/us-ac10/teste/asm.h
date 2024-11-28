#ifndef ASM_H 
#define ASM_H

#include <stdio.h>

#define NUM 10 
#define ARRAY_SENSOR_SIZE 5
#define TYPE_SIZE 25
#define UNIT_SIZE 10
#define BUFFER_VARIABLES 0
#define TIME_OUT 3000 // 5 min

typedef struct {
    int *array;     
    int read;      
    int write;      
    int size;      
} BufferCircular;
	//VAI TER TAMANHO 24 BYTES PORQUE K=8 (APONTADOR) (tem um GAP de 4 bytes no final)

typedef struct {
	BufferCircular *buffer;
	int *arrayMedias;
	int instanteTemporal;
	short timeOut;
    short write_counter;
    char sensor_id;
    char type[TYPE_SIZE];
    char unit[UNIT_SIZE];
} Sensor;		//o tamanho será 69 bytes, que é multiplo de k=23 (tem um GAP de 11 bytes no final)


Sensor *allocSensor(int bufferSize, int arrayMediasSize);
BufferCircular *allocBufferCircular();
void freeBufferCircular(BufferCircular *buffer);
int *allocArrayMedias();
void freeArrayMedias(int *arrayMedias);


char* get_outputFileName();
void serialize_info(Sensor *sensorPtr, int mediana, FILE *outputFile, int offset_time, int instanteAtualMilissegundos);
int isSensorInError(Sensor *sensorPtr, int offset_time, int instanteAtualMilissegundos);
#endif 

