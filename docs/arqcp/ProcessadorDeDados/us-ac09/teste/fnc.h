#ifndef ASM_H 
#define ASM_H 

#define NUM 10 
#define ARRAY_SENSOR_SIZE 1
#define TYPE_SIZE 23
#define UNIT_SIZE 10
#define BUFFER_VARIABLES 0
#define TIME_OUT 3000

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
	short timeOut;
    short write_counter;
    char sensor_id;
    char type[TYPE_SIZE];
    char unit[UNIT_SIZE];
} Sensor;

Sensor *allocSensor(int bufferSize, int arrayMediasSize);
Sensor **allocVetorSensores();
Sensor **reallocVectorSensores(Sensor ***vetorSensores, int newSize, int size);
void freeVectorSensores(Sensor **vetorSensores, int size) ;
void freeSensor(Sensor *sensor);
void enqueue_value(int* array, int length, int* read, int* write, int value);
//---------------------------------------------------------------------------------------

void insert_data_line(char *ptr_read, Sensor ***sensor_array,int *ptr_arr_size,int *ptr_counter);


#endif 

