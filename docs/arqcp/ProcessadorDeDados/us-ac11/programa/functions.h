#ifndef FUNCTION_H
#define FUNCTION_H

#include <stdio.h>

#define NUM 10 
#define ARRAY_SENSOR_SIZE 5
#define TYPE_SIZE 25
#define UNIT_SIZE 10
#define BUFFER_VARIABLES 0
#define TIME_OUT 300000 // 5 min

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

//---------------------------------------------------------------------------------------
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
int extract_token(char* input, char* token, int* output);
void enqueue_value(int* array, int length, int* read, int* write, int value);

//---------------------------------------------------------------------------------------
int extract_string(char* input_str, char* prefix,char size, char* result_str);
void remove_newline(char* str);
char check_array_has_sensor(Sensor** sensor_array, int sensor_id, int array_size);
int check_array_has_space(Sensor **sensor_array, int array_size);
Sensor *create_sensor(char *ptr_read, int counter,int sensor_id);
void insert_data_sensor(Sensor **sensor_array, char *ptr_read, int counter, int sensor_id, int array_size);
void print_sensor_data(Sensor **sensor_array, int pos);
void insert_data_line(char *ptr_read, Sensor ***sensor_array,int *ptr_arr_size,int *ptr_counter);

//---------------------------------------------------------------------------------------
void sort_array(int* vec, int num);
int mediana(int* vec, int num);
char* get_outputFileName();
void serialize_info(Sensor *sensorPtr, int mediana, FILE *outputFile, int offset_time, int instanteAtualMilissegundos);
int isSensorInError(Sensor *sensorPtr, int offset_time, int instanteAtualMilissegundos);

#endif
