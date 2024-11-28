#include <string.h>  
#include <stdlib.h>
#include "../../unity.h"
#include "asm.h" 

void call_func(void (*f)(Sensor *ptr_sensor, int mediana, FILE *outputFile, int offset_time, int instanteAtualMilissegundos), Sensor *ptr_sensor, int mediana, FILE *outputFile, int offset_time, int instanteAtualMilissegundos); 

void setUp(void) {
    // set stuff up here
}

void tearDown(void) {
    // clean stuff up here
}

void run_test(Sensor *ptr_sensor, int mediana, int instanteAtualMilissegundos, int offset_time, char *outputFilename)
{
	
	char *line = malloc(70);
	FILE *outputFile;
	char linhaLida[100] = "\0";
	int isError;
	char *ptr_read = linhaLida;
	
	
	if (line == NULL){
		TEST_ASSERT_NULL_MESSAGE(line, "Não foi possível alocar memória. O teste falhou.");
	}else{
		isError = isSensorInError(ptr_sensor, offset_time, instanteAtualMilissegundos);

		if (isError == 0){
			sprintf(line, "%d,%d,%s,%s,%d#\n",
					 ptr_sensor->sensor_id, ptr_sensor->write_counter,
					 ptr_sensor->type, ptr_sensor->unit, mediana);		
		}else{
			 sprintf(line, "%d,%hd,%s,%s,error#\n",
			 ptr_sensor->sensor_id, ptr_sensor->write_counter,
			 ptr_sensor->type, ptr_sensor->unit);
		}
	

		outputFile = fopen(outputFilename, "w");
		
		//serialize_info(ptr_sensor, mediana, outputFile, offset_time, instanteAtualMilissegundos);
		
		call_func(serialize_info, ptr_sensor, mediana, outputFile, offset_time, instanteAtualMilissegundos);
		
		fclose(outputFile);
		
		outputFile = fopen(outputFilename, "r");
	
		fgets(ptr_read, 100, outputFile);	
		
		if (mediana < 0 || offset_time < 0 || outputFile == NULL){
			TEST_ASSERT_EQUAL_STRING("\0", ptr_read);
		}else{
			TEST_ASSERT_EQUAL_STRING(line, ptr_read);
		}
		fclose(outputFile);
	}

	free(line);
	
	remove(outputFilename);
 
}

void test_InvalidMedian()
{ 	
	Sensor *ptr_sensor = allocSensor(5, 7);

    ptr_sensor->instanteTemporal = 1045345;
    ptr_sensor->timeOut = 3000;
    ptr_sensor->write_counter = 5;
    ptr_sensor->sensor_id = 2;
	strcpy(ptr_sensor->type, "atmospheric_temperature");
	strcpy(ptr_sensor->unit, "celsius");
	
	char* returnedOutputFilename = get_outputFileName();
    int length = strlen(returnedOutputFilename);
    char outputFilename[length + 1];
    strcpy(outputFilename, returnedOutputFilename);
    free(returnedOutputFilename);
    
    run_test(ptr_sensor, -1, 2045316, 1000167, outputFilename); 
    
    freeBufferCircular(ptr_sensor->buffer);
    freeArrayMedias(ptr_sensor->arrayMedias);
    free(ptr_sensor); 
}


void test_Vector_InvalidOffset()
{ 
	Sensor *ptr_sensor = allocSensor(5, 7);

    ptr_sensor->instanteTemporal = 1045345;
    ptr_sensor->timeOut = 3000;
    ptr_sensor->write_counter = 5;
    ptr_sensor->sensor_id = 2;
	strcpy(ptr_sensor->type, "atmospheric_temperature");
	strcpy(ptr_sensor->unit, "celsius");
	
	char* returnedOutputFilename = get_outputFileName();
    int length = strlen(returnedOutputFilename);
    char outputFilename[length + 1];
    strcpy(outputFilename, returnedOutputFilename);
    free(returnedOutputFilename);
	
    run_test(ptr_sensor, 15, 2045316, -1, outputFilename);
    
    freeBufferCircular(ptr_sensor->buffer);
    freeArrayMedias(ptr_sensor->arrayMedias);
    free(ptr_sensor);
}


void test_Vector_ValidSensor()
{ 
	Sensor *ptr_sensor = allocSensor(5, 7);

    ptr_sensor->instanteTemporal = 1045345;
    ptr_sensor->timeOut = 3000;
    ptr_sensor->write_counter = 5;
    ptr_sensor->sensor_id = 2;
	strcpy(ptr_sensor->type, "atmospheric_temperature");
	strcpy(ptr_sensor->unit, "celsius");
	
	char* returnedOutputFilename = get_outputFileName();
    int length = strlen(returnedOutputFilename);
    char outputFilename[length + 1];
    strcpy(outputFilename, returnedOutputFilename);
    free(returnedOutputFilename);
	
  run_test(ptr_sensor, 15, 2045316, 5067, outputFilename);
  
  freeBufferCircular(ptr_sensor->buffer);
    freeArrayMedias(ptr_sensor->arrayMedias);
    free(ptr_sensor);
}


void test_Vector_ValidSensorInError()
{ 
	Sensor *ptr_sensor = allocSensor(5, 7);

    ptr_sensor->instanteTemporal = 1045345;
    ptr_sensor->timeOut = 3000;
    ptr_sensor->write_counter = 5;
    ptr_sensor->sensor_id = 2;
	strcpy(ptr_sensor->type, "atmospheric_temperature");
	strcpy(ptr_sensor->unit, "celsius");
	
	char* returnedOutputFilename = get_outputFileName();
    int length = strlen(returnedOutputFilename);
    char outputFilename[length + 1];
    strcpy(outputFilename, returnedOutputFilename);
    free(returnedOutputFilename);
	
    run_test(ptr_sensor, 15, 2045316, 1002972, outputFilename);
    
    freeBufferCircular(ptr_sensor->buffer);
    freeArrayMedias(ptr_sensor->arrayMedias);
    free(ptr_sensor);
}



int main()
  { 

    UNITY_BEGIN();
    RUN_TEST(test_InvalidMedian);
    RUN_TEST(test_Vector_InvalidOffset);
    RUN_TEST(test_Vector_ValidSensor);
    RUN_TEST(test_Vector_ValidSensorInError);
    return UNITY_END();  

  } 
