#include <stdio.h>


int main()
{
    int n, acertos = 0;
    int respostas[20];
    int gabarito[20];

    scanf("%d",&n);
    for (int i = 1 ; i <= n; i++)
    {
       scanf("%d",&respostas[i]);
    }


    for (int i = 1 ; i <= n; i++)
    {
       scanf ("%d",&gabarito[i]);
    }

    for (int i = 1; i <= n;  i++)
    {
       if (respostas[i] == gabarito[i]){
          acertos++;
       }
    }

    if (acertos>1) {
      printf("%d acertos", acertos);
    } else {
        printf("%d acerto", acertos);
    }
    return 0;
}
