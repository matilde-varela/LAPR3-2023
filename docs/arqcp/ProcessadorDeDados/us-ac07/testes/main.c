#include <string.h>  
#include "../../unity.h"
#include "functions.h" 



Sensor* call_func(Sensor *(*)(int, int), int bufferSize, int arrayMediasSize);

Sensor** call_func_vetor(Sensor ** (*)());

Sensor** call_func_vetor2(Sensor ** (*)(Sensor***, int, int), Sensor ***vetorSensores, int newSize, int size);

int* call_func_array(int *(*f)(int *, int), int *arrayMedias, int newSize);

BufferCircular* call_func_buffer(BufferCircular *(*f)(BufferCircular *, int), BufferCircular *buffer, int newSize);


void setUp(void) {
    // set stuff up here
}

void tearDown(void) {
    // clean stuff up here
}


void run_test(int t_bufferSize, int t_arrayMediasSize, int t_newSizeBuffer, int t_newSizeArray) {
    Sensor *sensor = call_func(allocSensor, t_bufferSize, t_arrayMediasSize);


    TEST_ASSERT_NOT_NULL(sensor);
    TEST_ASSERT_NOT_NULL(sensor->buffer);
    TEST_ASSERT_NOT_NULL(sensor->buffer->array);
    TEST_ASSERT_NOT_NULL(sensor->arrayMedias);
    
    sensor->buffer = call_func_buffer(reallocBufferCircular, sensor->buffer, t_newSizeBuffer);
    TEST_ASSERT_NOT_NULL(sensor);
    TEST_ASSERT_NOT_NULL(sensor->buffer);
    
    sensor->arrayMedias = call_func_array(reallocArrayMedias, sensor->arrayMedias, t_newSizeArray);
    TEST_ASSERT_NOT_NULL(sensor);
    TEST_ASSERT_NOT_NULL(sensor->arrayMedias);


    freeSensor(sensor);
}

void test_AllocVetorSensores(int t_vector_size, int t_newSize) {
    Sensor **vetorSensores = call_func_vetor(allocVetorSensores);
    
    TEST_ASSERT_NOT_NULL(vetorSensores);

    for (int i = 0; i < t_vector_size; ++i) {
        TEST_ASSERT_NULL(vetorSensores[i]);
    }
    
    vetorSensores = call_func_vetor2(reallocVectorSensores, &vetorSensores, t_newSize, t_vector_size);
    
    TEST_ASSERT_NOT_NULL(vetorSensores);

    for (int i = 0; i < t_newSize; ++i) {
        TEST_ASSERT_NULL(vetorSensores[i]);
    }
    

    freeVectorSensores(vetorSensores, t_newSize);
}


void test_Zero()
{ 
    run_test(10, 20, 15, 21); 
}
void test_One()
{ 
    run_test(15,25, 17, 30); 
}
void test_Two()
{ 
    run_test(5, 6, 10, 7); 
}
void test_AllocVetorSensores_One(){
	test_AllocVetorSensores(VECTOR_SIZE, 30);
}
void test_AllocVetorSensores_Two(){
	test_AllocVetorSensores(VECTOR_SIZE, 15);
}




int main()
  { 

    UNITY_BEGIN();
    RUN_TEST(test_Zero);
    RUN_TEST(test_One);
    RUN_TEST(test_Two);
    RUN_TEST(test_AllocVetorSensores_One);
    RUN_TEST(test_AllocVetorSensores_Two);
    return UNITY_END();  

  } 






