#include <stdio.h>
#include <math.h>

int main(void) {
  float x, y,dist;
  int pts;

  for (int i=0; i < 10; i++) {
    scanf("%f %f",&x, &y);
    dist = sqrt(pow(x,2) +  pow(y,2));
    if (distance <= 1) {
      pontos = 10;
    }
    if (distanciaCentro > 1 && distanciaCentro <= 2) {
      pontos = 6;
    }
    if (distanciaCentro > 2 && distanciaCentro <= 3) {
      pontos = 4;
    }
    if (i>1 && acertou {
      distancia = sqrt(pow((ax-x),2) +  pow((ay-y),2));
      if (distancia>= 0 && distancia <= 1) {bonus = 5;}
      if (distancia > 1 && distancia <= 2) {bonus = 3;}
      if (distancia > 2 && distancia <= 3) {bonus = 2;}
    }

    ax = x;
    ay = y;

    total += (bonus + pontos);
  }
  printf("%d", total);
  
  return 0;
}