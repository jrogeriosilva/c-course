#include <stdio.h>
#include <stdlib.h>

int main(){
    int m, n;
    int ferteisTotal = 0, ferteisSemIrrigacao = 0;
    int ferteisIrrigados = 0, ferteisNaoIrrigados = 0;
    int setores[10][10] = {{0}};
    int contados[10][10] = {{0}};

    scanf("%d %d",&m, &n);

    for (int i = 0 ; i < m; ++i) {
        for (int j = 0; j < n; ++j) {
            scanf("%d", &setores[i][j]);
        }
    }

    // Conta Setores molhados, procurando pelo regadores.
    for (int i = 1; i < m-1; ++i) {
        for (int j = 1; j < n-1; ++j) {
            if (setores[i][j]==2) {
                //Baixo
                if(setores[i+1][j] == 1 && contados[i+1][j] == 0) {
                    ferteisIrrigados++;
                    contados[i+1][j] = 1;
                }
                //CIMA
                if(setores[i-1][j] == 1 && contados[i-1][j] == 0) {
                    ferteisIrrigados++;
                    contados[i-1][j] = 1;
                }
                //ESQUEDA
                if(setores[i][j-1] == 1 && contados[i][j-1] == 0) {
                    ferteisIrrigados++;
                    contados[i][j-1] = 1;
                }

                //DIREITA
                if(setores[i][j+1] == 1 && contados[i][j+1] == 0) {
                    ferteisIrrigados++;
                    contados[i][j+1] = 1;
                }

            }
        }
    }


    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < n; ++j) {
            if(setores[i][j] == 1) {
                ferteisTotal++;
            }
        }
    }

    ferteisNaoIrrigados = ferteisTotal - ferteisIrrigados;



    printf("%d %d", ferteisIrrigados, ferteisNaoIrrigados);

    return 0;
}