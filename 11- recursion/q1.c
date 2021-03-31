#include <stdio.h>
int r;
int somaDigitos(int n) {

    if (n == 0)
        return 0;
    return ( n%10 + somaDigitos(n/10));
}

int main () {
    int d;
    scanf("%d", &d);
    r = somaDigitos(d);

    if (r < 0)
        r *= -1;

    printf ("%d",r);
    return 0;
}