#include <stdio.h>
int r;
int somaDigitos(int n) {

    if (n == 0)
        return 0;
    if (n < 0)
        n *= -1;
    return ( n%10 + somaDigitos(n/10));
}

int main () {
    int d;
    scanf("%d", &d);
    r = somaDigitos(d);



    printf ("%d",r);
    return 0;
}