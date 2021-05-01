#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

int main() {

	srand(time(NULL));
	FILE *arq = fopen("pts.txt", "w");

	for(int i = 0; i < 100; i++) {
		float x, y;
		x = 50 - 100*((float)rand())/RAND_MAX;
		y = 50 - 100*((float)rand())/RAND_MAX;
		fprintf(arq, "%.02f %.02f\n", x, y);
	}

	fclose(arq);
	return 0;
}
