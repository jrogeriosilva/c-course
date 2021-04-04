#include <stdio.h>

int potencia(int base, int expoente) {
    if (expoente == 0)
        return 1;
    else
        return base * potencia(base, expoente - 1);
}



int main () {
    int base, expoente;
    scanf("%d %d", &base, &expoente);
    printf ("%d", potencia(base,expoente) );
    return 0;
}