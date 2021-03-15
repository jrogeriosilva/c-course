#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>



int ehValida(char *str) {
    // 0 = Inválido
    // 1 = Brasileiro
    // 2 = Mercosul
    int padrao = 0;


    // Verificando se comprimento da string passada é valida
    if (strlen(str) == 8 || strlen(str) == 7) {
    } else {
        return 0;
    }

    // Verificando Se Existe Separador (-) ou Algarismo.
    if (str[3] == '-' || isdigit(str[3])) {
        if (str[3] == '-') {
            padrao = 1;
        } else{
            padrao = 2;
        }
    } else {
        return 0;
    }

    // LLL
    for (int i = 0; i < 3; ++i) {
        if (isupper(str[i])){
        } else {
            return 0;
        }
    }

    // Verificando Se o str[4] é  digito ou Letra
    // E Se ele corresponde ao padrão
    if (padrao == 1 && isdigit(str[4])){
        padrao = 1;
    } else if(padrao == 2 && isupper(str[4])){
        padrao = 2;
    } else {
        padrao = 0;
    }

    // Verificando restante da string
    for (int i = 5; i < strlen(str); ++i) {
        if (isdigit(str[i])) {
        }else {
            return 0;
        }
    }

    // Checa Se o tamanho da String Corresponde ao tamanho esperado
    if (strlen(str) == 8 && padrao == 1) {
        padrao = 1;
    } else if (strlen(str) == 7 && padrao == 2) {
        padrao =  2;
    } else {
        return 0;
    }

    return padrao;
}


int main() {
    char placa[100];

    scanf("%s", placa);


    switch (ehValida(placa)) {
        case 0:
            printf("invalido");
            break;

        case 1:
            printf("brasileiro");
            break;

        case 2:
            printf("mercosul");
            break;
    }

    return 0;
}