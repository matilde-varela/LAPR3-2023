#ifndef FUNCTION_H
#define FUNCTION_H

#define NUM 10 
#define VECTOR_SIZE 20
#define TYPE_SIZE 25
#define UNIT_SIZE 10

typedef struct {
	int mediana;
	short write_counter;
    char sensor_id;
    char type[TYPE_SIZE];
    char unit[UNIT_SIZE];
}SaidaDeDados;

void alocateSaidaDeDados(char input[]);

SaidaDeDados *allocSaidaDeDados();
SaidaDeDados *reallocSaidaDeDados(SaidaDeDados *saidaDados);
void freeSaidaDeDados(SaidaDeDados *saidaDados);
SaidaDeDados **allocVetorSaidaDados();
SaidaDeDados **reallocVectorSaidaDados(SaidaDeDados ***vetorSaidaDados, int newSize, int size);
void freeVectorSaidaDados(SaidaDeDados **vetorSaidaDados, int size); 

#endif
