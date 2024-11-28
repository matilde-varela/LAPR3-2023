#include "function.h"
#include <stdio.h>
#include <sys/stat.h>
#include <dirent.h>
#include <errno.h>
#include <stdlib.h>

/*
* Verifica se o diretório existe e caso não exista, cria o diretório
*/
void alocateSaidaDeDados(char b[]){
	DIR* dir = opendir(b);
	
	if(dir){
		printf("O diretório já existe existe!!\n");
		closedir(dir);
	} else if (ENOENT == errno){
		printf("O diretório não existe!\nA proceder à criação do diretório!\n");
		
		if (mkdir(b, 0700) == 0) {
            printf("Diretório criado com sucesso!\n");
        } else {
            printf("Erro ao criar o diretório.\n");
        }
	} else{
		printf("Ocorreu um erro na tentativa de abrir o diretório desejado.\n");
	}
}


//---------------------------SAIDA DE DADOS--------------------------------

/*
* Vai alocar espaço na memória para a SaidaDeDados
*/
SaidaDeDados *allocSaidaDeDados() {
    SaidaDeDados *saidaDados = (SaidaDeDados *)malloc(sizeof(SaidaDeDados));

    if (saidaDados == NULL) {
        return NULL;
    }
    
    saidaDados->mediana = 0;
    saidaDados->write_counter = 0;
    saidaDados->sensor_id = '\0';
    for (int i = 0; i < TYPE_SIZE; i++) {
        saidaDados->type[i] = '\0';
    }
    for (int i = 0; i < UNIT_SIZE; i++) {
        saidaDados->unit[i] = '\0';
    }
	
    return saidaDados;
}

/*
* Vai realocar espaço na memória para a SaidaDeDados
*/
SaidaDeDados *reallocSaidaDeDados(SaidaDeDados *saidaDados) {
    SaidaDeDados *novaSaidaDados = (SaidaDeDados *)realloc(saidaDados, sizeof(SaidaDeDados));
    if (novaSaidaDados == NULL) {
        return NULL;
    }
    return novaSaidaDados;
}

/*
* Vai libertar o espaço que tinha sido alocado para a saidaDeDados
*/
void freeSaidaDeDados(SaidaDeDados *saidaDados) {
    free(saidaDados);
}

//----------------------------VECTOR SAIDA DE DADOS-----------------------------

/*
* Vai alocar espaço na memória para o vetor de saidaDeDados
*/
SaidaDeDados **allocVetorSaidaDados(){
	SaidaDeDados **vetorSaidaDados = (SaidaDeDados **)calloc(VECTOR_SIZE, sizeof(SaidaDeDados *));
	if (vetorSaidaDados == NULL) {
		exit(-1);
	}

	return vetorSaidaDados;
}

/*
* Vai realocar espaço na memória para o vetor de saidaDeDados
*/
SaidaDeDados **reallocVectorSaidaDados(SaidaDeDados ***vetorSaidaDados, int newSize, int size) {
    SaidaDeDados **novoVetor = (SaidaDeDados **)realloc(*vetorSaidaDados, newSize * sizeof(SaidaDeDados *));
    if (novoVetor != NULL) {
		*vetorSaidaDados = novoVetor;
    } else {
        exit(-1);
    } 
    
     if (newSize > size) {
		for (int i = size; i < newSize; i++) {
			(*vetorSaidaDados)[i] = 0;
		}
	}
        
    return *vetorSaidaDados;
}

/*
* Vai libertar o espaço que tinha sido alocado para o vetor de saidaDeDados
*/
void freeVectorSaidaDados(SaidaDeDados **vetorSaidaDados, int size) {
	for (int i = 0; i < size; i++) {
		if (vetorSaidaDados[i] != NULL) {
			freeSaidaDeDados(vetorSaidaDados[i]);
		}
	}
	free(vetorSaidaDados);
}



