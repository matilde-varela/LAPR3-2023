#include <string.h>  
#include "../../unity.h"
#include "function.h" 



SaidaDeDados* call_func_saidadedados(SaidaDeDados * (*)());

SaidaDeDados** call_func_vetor(SaidaDeDados ** (*)());

SaidaDeDados** call_func_vetor2(SaidaDeDados ** (*)(SaidaDeDados ***,  int, int), SaidaDeDados ***vetorSaida,  int newSize, int size);




void setUp(void) {
    // set stuff up here
}

void tearDown(void) {
    // clean stuff up here
}


void run_test() {
    SaidaDeDados *saida = call_func_saidadedados(allocSaidaDeDados);


    TEST_ASSERT_NOT_NULL(saida);


    freeSaidaDeDados(saida);
}

void test_AllocVetor(int t_vector_size, int t_newSize) {
    SaidaDeDados **vetorSaidaDados = call_func_vetor(allocVetorSaidaDados);
    
    TEST_ASSERT_NOT_NULL(vetorSaidaDados);

    for (int i = 0; i < t_vector_size; ++i) {
        TEST_ASSERT_NULL(vetorSaidaDados[i]);
    }
    
    vetorSaidaDados = call_func_vetor2(reallocVectorSaidaDados, &vetorSaidaDados, t_newSize, t_vector_size);
    
    TEST_ASSERT_NOT_NULL(vetorSaidaDados);

    for (int i = 0; i < t_newSize; ++i) {
        TEST_ASSERT_NULL(vetorSaidaDados[i]);
    }
    

    freeVectorSaidaDados(vetorSaidaDados, t_newSize);
}



void test_One()
{ 
    run_test(); 
}
void test_AllocVetor_One(){
	test_AllocVetor(VECTOR_SIZE, 30);
}
void test_AllocVetor_Two(){
	test_AllocVetor(VECTOR_SIZE, 15);
}




int main()
  { 

    UNITY_BEGIN();
    RUN_TEST(test_One);
    RUN_TEST(test_AllocVetor_One);
    RUN_TEST(test_AllocVetor_Two);
    return UNITY_END();  

  } 






