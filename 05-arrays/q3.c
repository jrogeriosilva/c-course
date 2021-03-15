#include <stdio.h>

int main(){
  int alturas[30];
  int n, alt;
  // Dados da Ponte
  int cordprimeiroPonto = 0,primeiroPonto = 0, comprimento = 0;
  
  // Recebe Quantidade de Alturas, e respectivas alturs
  scanf("%d", &n);
  for (int i = 0; i < n; i++){
    scanf("%d", &alt);
    alturas[i] = alt;
  }


  // Procura Ponto Mais alto E salva sua Altura e Localização no Vetor
  for (int i = 0; i < n; i++){
    if(alturas[i] > primeiroPonto) {
      primeiroPonto = alturas[i];
      cordprimeiroPonto = i;
    }
  }
  
  
  // Procura um segundo Ponto igual ao primeiro apos cordenada do primeiro ponto.
  for (int i = cordprimeiroPonto+1; i < n; i++){
    if (alturas[i] != primeiroPonto) {
      comprimento++;
    } else {
      break;
    }
  }

  // printf("CORD: %d\n",cordprimeiroPonto);
  printf("%d",comprimento);
  // printf("ALT PRIM: %d\n",primeiroPonto);

  return 0;
}