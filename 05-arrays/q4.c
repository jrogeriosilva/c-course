#include <stdio.h>

//4 3 7 4 2 8 9 5 2 6

int main() {

    int v[10] = {0}, aux[10]={0};
    aux[0] = 1;

    for(int i=0; i<10; i++)
    {
        scanf("%d", &v[i]);
    }

    int i = v[0];
    while(1)
    {
        aux[i]++;
        if(aux[i] == 2)
        {
            printf("%d", i);
            break;
        }
        i = v[i];
    }

    return 0;
}