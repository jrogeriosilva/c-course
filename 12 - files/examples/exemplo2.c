
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {

	FILE *arq = fopen("pts.txt", "r");
	if(arq == NULL) {
		fprintf(stderr, "Não foi possível abrir o arquivo\n");
		return 1;
	}

	float x, y;
	while(fscanf(arq, "%f %f", &x, &y) != EOF) {
		printf("Ponto lido: %.02f %.02f\n", x, y);
	}

	fclose(arq);

	return 0;
}
