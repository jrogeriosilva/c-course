#include <stdio.h>


double phi(int numFracoes) {
    if (numFracoes == 0)
        return numFracoes;
    return 1 + 1/phi(numFracoes - 1);
}

int main () {
    printf ("%.10f",phi(30));
    return 0;
}