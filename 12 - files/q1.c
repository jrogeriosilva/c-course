#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main (){
	FILE *times = fopen("times.txt", "r");
	FILE *partidas = fopen("partidas.csv", "r");
	char time[100];
	int pontuacao = 0;

	while(fscanf(arq, "%s", &palavra) != EOF) {
		if (strlen(palavra) > strlen(maiorPalavra)){
			strcpy(maiorPalavra, palavra);
		}
	}
	printf("%s \n", maiorPalavra);
	return 0;
}