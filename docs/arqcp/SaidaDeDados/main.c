#include <stdio.h>
#include "function.h"


int main(int argc,char *argv[]) {
	printf("**Função para a alocação de dados e configuração da componente do Saida de Dados**\n\n");	
	
	char a[20];
	char b[20];
	int c = -1;
	
	sscanf(argv[1], "%s", a);
	sscanf(argv[2], "%s", b);
	sscanf(argv[3], "%d", &c);
	
	printf("Separação dos conteúdos passados pelo main:\n");
	for(int i = 1; i < argc; i++){
		printf("\nargv[%d]: %s", i, argv[i]);
	}
	printf("\n");
	
	alocateSaidaDeDados(b);
	
	printf("\n");
	
//-----------TESTAR A ALOCAÇÃO DA SAIDA DE DADOS----------
    SaidaDeDados *saida = allocSaidaDeDados();
    if (saida == NULL) {
        printf("Erro ao alocar memória.\n");
        return 1;
    } else {
		printf("Alocação concluída com sucesso\n");
	}

    SaidaDeDados *novaSaida = reallocSaidaDeDados(saida);
    if (novaSaida == NULL) {
        printf("Erro ao realocar memória.\n");
        freeSaidaDeDados(saida);
        return 1;
    } else {
		printf("Realocação concluída com sucesso\n");
	}

    freeSaidaDeDados(novaSaida);


    SaidaDeDados **vetorSaidaDados = allocVetorSaidaDados();
    if (vetorSaidaDados == NULL) {
        printf("Erro ao alocar memória para o vetor.\n");
        return 1;
    } else {
		printf("Alocação do vetor concluída com sucesso\n");
	}

    int novoTamanho = 30;
    vetorSaidaDados = reallocVectorSaidaDados(&vetorSaidaDados, novoTamanho, VECTOR_SIZE);

    freeVectorSaidaDados(vetorSaidaDados, novoTamanho);
	
	return 0;
}
