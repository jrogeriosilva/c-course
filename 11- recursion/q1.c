#include <stdio.h>
#include <stdlib.h>

int somaDigitos(int n) {
	if (n == 0)
		return 0;
	else
		return ( n%10 + somaDigitos(n/10));
}



int main () {
	int d;
	scanf("%d", &d);
	printf ("%d",somaDigitos(d));
	return 0;
}