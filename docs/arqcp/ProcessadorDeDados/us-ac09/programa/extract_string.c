#include <stdio.h>
#include <string.h>


int extract_string(char* input_str, char* prefix,char size, char* result_str) {
    const char* ptr_read = input_str;
																	
    while (*ptr_read != '\0' && strncmp(ptr_read, prefix, size) != 0) { //Encontra o token [A função strncmp compara os primeiros n caracteres de duas strings.]
        ptr_read++;
    }

    if (*ptr_read == '\0') {
        return -1;													 	// Token não encontrado na string.
    }

    ptr_read += size; 									    			// Avança o token

    
    while (*ptr_read != '\0' && *ptr_read != '#') {						// Copia string até encontrar '#'
        *result_str = *ptr_read;
        ptr_read++;
        result_str++;
    }

    *result_str = '\0';													// Adiciona o carater nulo ao final

    return 1;
}


void remove_newline(char* str) {
    int length = strlen(str);

    if (length > 0) {													// Verifica se a string está vazia
        if (str[length - 1] == '\n') {									// Verifica se o último carater é '\n'
            str[length - 1] = '\0';										// Substitui '\n' por '\0'
        }
    }
}
