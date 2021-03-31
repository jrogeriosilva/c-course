#include <stdio.h>

int numeroOcorrenciasVetor(int *v, int n, int x) {

    if (n==0)
        return 0;
    return (v[n-1]==x) + numeroOcorrenciasVetor(v, n-1, x);
}



int main () {

    int n, x;
    scanf("%d", &n);

    int v[n];
    for (int i = 0; i < n; ++i)
        scanf("%d", &v[i]);

    scanf("%d", &x);

    printf("%d", numeroOcorrenciasVetor(v, n, x));

    return 0;
}