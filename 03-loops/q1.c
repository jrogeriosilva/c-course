#include <stdio.h>

int main()
{
    float alturaPapel, larguraPapel, larguraBolso;
    int dobras = 0;
    
    scanf("%f", &alturaPapel);
    scanf("%f", &larguraPapel);
    scanf("%f", &larguraBolso);
    
    while (alturaPapel >= larguraBolso && larguraPapel >= larguraBolso) {
        if (alturaPapel >= larguraPapel ) {
            alturaPapel = alturaPapel/2;
        } else {
            larguraPapel = larguraPapel/2;
        }
        dobras++;
    }
    
    printf ("%d", dobras);
  
    return 0;
}
