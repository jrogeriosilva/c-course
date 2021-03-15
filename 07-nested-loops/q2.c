#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char meses[][30] = {"Janeiro", "Fevereiro", "Marco", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"};
int chuva[12];
int aux = 0;
int aux2 = 0;
int ranking[12] = {1,2,3,4,5,6,7,8,9,10,11,12};

int main() {
    for (int i = 0; i < 12; ++i) {
        scanf("%d", &chuva[i]);
    }

    for (int i = 0; i < 12; ++i) {
        for (int j = 0; j < 12; ++j) {
            if (chuva[i] > chuva[j]){
                aux = chuva[i];
                aux2 = ranking[i];

                chuva[i] = chuva[j];
                ranking[i] = ranking[j];

                chuva[j] = aux;
                ranking[j] = aux2;
            }
        }
    }


    for (int i = 0; i < 12; ++i) {
        printf("%s %d\n", meses[ranking[i]-1], chuva[i]);
    }

    return 0;
}
