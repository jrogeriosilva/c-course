#include <stdio.h>
#include <math.h>
int securePoints = 0;
int initialPoint = 0;

// Checa a Altura do ponto
float groundHeight(float x, float y) {
  return (sin(cos(y) + x) + cos(y + sin(x)));
}

// Checa os 5 pontos de contato da sonda
int safePoint(float x, float y) {
    float p0 = groundHeight(x,y);
    float p1 = groundHeight(x + 0.2, y + 0.2);
    float p2 = groundHeight(x - 0.2, y - 0.2);
    float p3 = groundHeight(x + 0.2, y - 0.2);
    float p4 = groundHeight(x - 0.2, y + 0.2);


    // printf("\n%f %f %f %f %f \n",p0,p1,p2,p3,p4);
    

    if (p0 < 0 || p0 > 2) {
      return 0;
    } else if (p1 > 2
              || p2 > 2
              || p3 > 2
              || p4 > 2
              || p1 < 0
              || p2 < 0
              || p3 < 0
              || p4 < 0
              ) {return 0; } else {
                
                securePoints++;
                return 1;
              }
                  
}


int safeInitialPoint(float x, float y) {
    float p0 = groundHeight(x,y);
    float p1 = groundHeight(x + 0.2, y + 0.2);
    float p2 = groundHeight(x - 0.2, y - 0.2);
    float p3 = groundHeight(x + 0.2, y - 0.2);
    float p4 = groundHeight(x - 0.2, y + 0.2);


    // printf("\n%f %f %f %f %f \n",p0,p1,p2,p3,p4);
    

    if (p0 < 0 || p0 > 2) {
      return 0;
    } else if (p1 > 2
              || p2 > 2
              || p3 > 2
              || p4 > 2
              || p1 < 0
              || p2 < 0
              || p3 < 0
              || p4 < 0
              ) {return 0; } else {
                initialPoint = 1;
                return 1;
              }
                  
}



void safeArea(float x, float y) {
    if (safeInitialPoint(x, y)){
      safePoint(x+2, y);
      safePoint(x-2, y);
      safePoint(x, y-2);
      safePoint(x, y+2);
    } else {}
}

int main() {

float x, y;
scanf("%f %f", &x, &y);
safeArea(x, y);
if (initialPoint == 0) {
    printf("troque de coordenada");
} else if (securePoints == 0 || securePoints == 1) {
    printf("inseguro");
} else if (securePoints == 2 || securePoints == 3) {
    printf("relativamente seguro");
} else {
    printf("seguro");
}
return 0;
}