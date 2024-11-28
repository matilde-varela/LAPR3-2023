#include <string.h>  
#include "../../unity.h"
#include "fnc.h" 


void call_func(void (*f)(char *ptr_line, Sensor ***sensor_array, int *ptr_size,int *ptr_counter), char *ptr_line, Sensor ***sensor_array, int *ptr_size,int *ptr_counter);  

void setUp(void) {
    // set stuff up here
}

void tearDown(void) {
    // clean stuff up here
}

void run_test1(char *ptr_line, Sensor **expected)
{
	Sensor **sensor_array = allocVetorSensores();
	Sensor ***ptr_sensor;
	ptr_sensor = &sensor_array;

	int array_size = ARRAY_SENSOR_SIZE;
	int *ptr_arr_size = &array_size;
	
	int counter = 0;
	int *ptr_counter = &counter;
	
	call_func(insert_data_line, ptr_line, ptr_sensor, ptr_arr_size, ptr_counter);
	
    TEST_ASSERT_EQUAL_INT(expected[0]->sensor_id, sensor_array[0]->sensor_id);
    TEST_ASSERT_EQUAL_INT(expected[0]->instanteTemporal, sensor_array[0]->instanteTemporal);
    TEST_ASSERT_EQUAL_INT(expected[0]->write_counter, sensor_array[0]->write_counter);
    TEST_ASSERT_EQUAL_INT(expected[0]->timeOut, sensor_array[0]->timeOut);
 	TEST_ASSERT_EQUAL_STRING(expected[0]->unit, sensor_array[0]->unit);
	TEST_ASSERT_EQUAL_STRING(expected[0]->type, sensor_array[0]->type);
	for(int i = 0; i < NUM; i++){
		TEST_ASSERT_EQUAL_INT(expected[0]->buffer->array[i], sensor_array[0]->buffer->array[i]);
	}
	freeVectorSensores(sensor_array,ARRAY_SENSOR_SIZE);
}

void run_test2(char *ptr_line, Sensor **sensor_array, Sensor *expected)
{
	Sensor ***ptr_sensor;
	ptr_sensor = &sensor_array;

	int array_size = ARRAY_SENSOR_SIZE;
	int *ptr_arr_size = &array_size;
	
	int counter = 1;
	int *ptr_counter = &counter;
	
	call_func(insert_data_line, ptr_line, ptr_sensor, ptr_arr_size, ptr_counter);
	
    TEST_ASSERT_EQUAL_INT(expected->sensor_id, sensor_array[0]->sensor_id);
    TEST_ASSERT_EQUAL_INT(expected->instanteTemporal, sensor_array[0]->instanteTemporal);
    TEST_ASSERT_EQUAL_INT(expected->write_counter, sensor_array[0]->write_counter);
    TEST_ASSERT_EQUAL_INT(expected->timeOut, sensor_array[0]->timeOut);
 	TEST_ASSERT_EQUAL_STRING(expected->unit, sensor_array[0]->unit);
	TEST_ASSERT_EQUAL_STRING(expected->type, sensor_array[0]->type);
	for(int i = 0; i < NUM; i++){
		TEST_ASSERT_EQUAL_INT(expected->buffer->array[i], sensor_array[0]->buffer->array[i]);
	}
	freeVectorSensores(sensor_array,ARRAY_SENSOR_SIZE);
}

void run_test3(char *ptr_line, Sensor **sensor_array, Sensor **expected)
{
	Sensor ***ptr_sensor;
	ptr_sensor = &sensor_array;

	int array_size = ARRAY_SENSOR_SIZE;
	int *ptr_arr_size = &array_size;
	
	int counter = 1;
	int *ptr_counter = &counter;
	
	call_func(insert_data_line, ptr_line, ptr_sensor, ptr_arr_size, ptr_counter);
	
	for(int j = 0; j <= 1; j++){
		TEST_ASSERT_EQUAL_INT(expected[j]->sensor_id, sensor_array[j]->sensor_id);
		TEST_ASSERT_EQUAL_INT(expected[j]->instanteTemporal, sensor_array[j]->instanteTemporal);
		TEST_ASSERT_EQUAL_INT(expected[j]->write_counter, sensor_array[j]->write_counter);
		TEST_ASSERT_EQUAL_INT(expected[j]->timeOut, sensor_array[j]->timeOut);
		TEST_ASSERT_EQUAL_STRING(expected[j]->unit, sensor_array[j]->unit);
		TEST_ASSERT_EQUAL_STRING(expected[j]->type, sensor_array[j]->type);
		for(int i = 0; i < NUM; i++){
			TEST_ASSERT_EQUAL_INT(expected[j]->buffer->array[i], sensor_array[j]->buffer->array[i]);
		}
	}
	freeVectorSensores(sensor_array,2);
}



void test_insert_info_new_sensor()
{ 
	char* line = "sensor_id:5#type:atmospheric_humidity#value:43.00#unit:percentage#time:1034027";

	Sensor** sensores = allocVetorSensores();
	Sensor* sensor = allocSensor(NUM,NUM);
	sensor->sensor_id = 5;	
	sensor->write_counter = 0;
	sensor->timeOut = TIME_OUT;
	sensor->instanteTemporal = 1034027;
	strcpy(sensor->type,"atmospheric_humidity");
	strcpy(sensor->unit,"percentage");

	int value = 4300;
	enqueue_value(sensor->buffer->array , sensor->buffer->size, &(sensor->buffer->read), &(sensor->buffer->write), value);			
	
	sensores[0] = sensor;

	run_test1(line,sensores);
	freeVectorSensores(sensores,ARRAY_SENSOR_SIZE);
}

void test_insert_info_existent_sensor()
{ 
	char* line = "sensor_id:5#type:atmospheric_humidity#value:46.00#unit:percentage#time:1034030";
	//--------------------------------------
	Sensor* expected = allocSensor(NUM,NUM);
	expected->sensor_id = 5;	
	expected->write_counter = 1;
	expected->timeOut = TIME_OUT;
	expected->instanteTemporal = 1034030;
	strcpy(expected->type,"atmospheric_humidity");
	strcpy(expected->unit,"percentage");
	int value = 4300;
	enqueue_value(expected->buffer->array , expected->buffer->size, &(expected->buffer->read), &(expected->buffer->write), value);			
	value = 4600;
	enqueue_value(expected->buffer->array , expected->buffer->size, &(expected->buffer->read), &(expected->buffer->write), value);			
	//--------------------------------------
	Sensor** sensores = allocVetorSensores();
	Sensor* sensor = allocSensor(NUM,NUM);
	sensor->sensor_id = 5;	
	sensor->write_counter = 0;
	sensor->timeOut = TIME_OUT;
	sensor->instanteTemporal = 1034027;
	strcpy(sensor->type,"atmospheric_humidity");
	strcpy(sensor->unit,"percentage");
	value = 4300;
	enqueue_value(sensor->buffer->array , sensor->buffer->size, &(sensor->buffer->read), &(sensor->buffer->write), value);			
	sensores[0] = sensor;
	//--------------------------------------
		
	run_test2(line,sensores,expected);
	freeSensor(expected);
}

void test_insert_info_realloc()
{ 
	//--------------------------------------
	Sensor** sensores = allocVetorSensores();
	Sensor ***ptr_sensor;
	ptr_sensor = &sensores;
	(*ptr_sensor)  = reallocVectorSensores(ptr_sensor, 1, ARRAY_SENSOR_SIZE);
		
	Sensor** expected = allocVetorSensores();
	//--Array-------------------------------
	Sensor* sensor = allocSensor(NUM,NUM);
	sensor->sensor_id = 5;	
	sensor->write_counter = 0;
	sensor->timeOut = TIME_OUT;
	sensor->instanteTemporal = 1034027;
	strcpy(sensor->type,"atmospheric_humidity");
	strcpy(sensor->unit,"percentage");
	int value = 4300;
	enqueue_value(sensor->buffer->array , sensor->buffer->size, &(sensor->buffer->read), &(sensor->buffer->write), value);			
	sensores[0] = sensor;
	//--Expected-------------------------------
	Sensor* sensor2 = allocSensor(NUM,NUM);
	sensor2->sensor_id = 5;	
	sensor2->write_counter = 0;
	sensor2->timeOut = TIME_OUT;
	sensor2->instanteTemporal = 1034027;
	strcpy(sensor2->type,"atmospheric_humidity");
	strcpy(sensor2->unit,"percentage");
	value = 4300;
	enqueue_value(sensor2->buffer->array , sensor2->buffer->size, &(sensor2->buffer->read), &(sensor2->buffer->write), value);	
	expected[0] = sensor2;
	
	Sensor* sensor1 = allocSensor(NUM,NUM);
	sensor1->sensor_id = 6;	
	sensor1->write_counter = 1;
	sensor1->timeOut = TIME_OUT;
	sensor1->instanteTemporal = 1034030;
	strcpy(sensor1->type,"atmospheric_humidity");
	strcpy(sensor1->unit,"percentage");
	value = 4600;
	enqueue_value(sensor1->buffer->array , sensor1->buffer->size, &(sensor1->buffer->read), &(sensor1->buffer->write), value);	
	expected[1] = sensor1;
	//--------------------------------------	
	char* line = "sensor_id:6#type:atmospheric_humidity#value:46.00#unit:percentage#time:1034030";
	
	run_test3(line,sensores,expected);
	freeVectorSensores(expected,ARRAY_SENSOR_SIZE);
	freeSensor(sensor1);
}

int main()
  { 

    UNITY_BEGIN();
    RUN_TEST(test_insert_info_new_sensor);
    RUN_TEST(test_insert_info_existent_sensor);
    RUN_TEST(test_insert_info_realloc);
    return UNITY_END();  

  } 
