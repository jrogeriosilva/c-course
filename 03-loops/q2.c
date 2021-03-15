#include <stdio.h>
#include <math.h>
#include <stdbool.h>

int main(void) {
  float x, y, comprimentoTeia, ax, ay, distancia;
  int alvos;
  bool s = true;
 
  scanf("%f %f",&x, &y);
  scanf("%f", &comprimentoTeia);
  scanf("%d", &alvos);  
  
  for (int i = 0; i < alvos; i++) {
    scanf("%f %f",&ax, &ay);

    distancia = sqrt(pow((x - ax),2) +  pow((y - ay),2));

    if (comprimentoTeia >= distancia) {
      x = (2*ax) -x;
    } else if (s !=false) {
      s = false;
    }
  }

if (s) {
  printf("S");
}else {
  printf("N");
}
  return 0;
}