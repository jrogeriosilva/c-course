#include <stdio.h>


int main (){
    int empates = 0;
    int time1, time2;
    int m;
    int placares[20][20];

    scanf("%d", &m);

    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < m; ++j) {
            scanf("%d", &placares[i][j]);
        }
    }

    //Analisa cada Jogo
    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < m; ++j) {
            time1 = i;
            time2 = j;
            if(i != j && placares[time1][time2] == placares[time2][time1]) {
                empates++;
            }
        }
    }

    printf("%d", empates/2);

    return 0;
}