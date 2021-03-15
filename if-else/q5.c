#include <stdio.h>

int main()
{
  int pontosTime, partidasRestantes, pontosNecessarios;
  
  printf("Quantos pontos possui o time:");
  scanf("%d", &pontosTime);

  printf("Quantas partidas restam:");
  scanf("%d", &partidasRestantes);

  printf("Quantos pontos são necessários:");
  scanf("%d", &pontosNecessarios);

  if (pontosTime >= pontosNecessarios) {
      printf("O time já está classificado");
  } else if (pontosNecessarios > (partidasRestantes + pontosTime)) {
        printf("Não é possível se classificar");
      } else { printf("E possível se classificar");
  }

  return 0;
}

