#ifndef FUNCTION_H
#define FUNCTION_H

#define NUM 10 
#define ARRAY_SENSOR_SIZE 20
#define TYPE_SIZE 25
#define UNIT_SIZE 10
#define BUFFER_VARIABLES 0


typedef struct {
    int *array;     
    int read;      
    int write;      
    int size;      
} BufferCircular;


typedef struct {
	BufferCircular *buffer;
	int *arrayMedias;
	int instanteTemporal;
	int timeOut;
    short write_counter;
    char sensor_id;
    char type[TYPE_SIZE];
    char unit[UNIT_SIZE];
} Sensor;	


void alocateProcessadorDeDados(char input[]);

BufferCircular *allocBufferCircular();
BufferCircular *reallocBufferCircular(BufferCircular *buffer, int newSize);
void freeBufferCircular(BufferCircular *buffer);
int *allocArrayMedias();
int *reallocArrayMedias(int *arrayMedias, int newSize);
void freeArrayMedias(int *arrayMedias);
Sensor *allocSensor(int bufferSize, int arrayMediasSize);
void freeSensor(Sensor *sensor);
Sensor **allocVetorSensores();
Sensor **reallocVectorSensores(Sensor ***vetorSensores, int newSize, int size);
void freeVectorSensores(Sensor **vetorSensores, int size) ;

#endif
