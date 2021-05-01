#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main (){
	FILE *arq = fopen("domcasmurro.txt", "r");
	char palavra[200];
	char maiorPalavra[200] = {'o','i'};
	while(fscanf(arq, "%s", &palavra) != EOF) {
		if (strlen(palavra) > strlen(maiorPalavra)){
			strcpy(maiorPalavra, palavra);
		}
	}
	printf("%s \n", maiorPalavra);
	return 0;
}