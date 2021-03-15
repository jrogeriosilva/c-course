#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void)
{
    int m, n, acertos = 0;
    int mArray[30] = {0};
    int nArray[50] = {0};

    scanf("%d", &m);
    scanf("%d", &n);

    for (int i = 0; i < m; ++i) {
        scanf("%d", &mArray[i]);
    }

    for (int j = 0; j < n; ++j) {
        scanf("%d", &nArray[j]);
    }

    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < n; ++j) {
            if (mArray[i] == nArray[j]){
                acertos++;
            }
        }
    }

    printf("%d", acertos);
    return 0;
}