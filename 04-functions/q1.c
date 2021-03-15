#include <stdio.h>

int minTotal (int hora, int minuto){
  int res = (hora*60) + minuto;
  return res;
}

void printRonda (h0, m0, o) {
  int firstPatrol = minTotal(h0, m0);
  int nextPatrol;
  if (o) {      
          // for (int i = 0; i <= 4;i++) {
          //   if (i==0) { nextPatrol = firstPatrol;}
          //   if (i==1) {nextPatrol = firstPatrol + 60;}
          //   if (i==2) {nextPatrol = firstPatrol +  130;}
          //   if (i==3) {nextPatrol = firstPatrol +  280;}
          //   if (i==4) {nextPatrol = firstPatrol +  725;}

          //   // Próximo Dia
          //   if (nextPatrol > 1.439) {
          //     nextPatrol = nextPatrol - 720;
          //   }
            
          //   int h = nextPatrol/60;
          //   int m = nextPatrol%60;
          //   printf("%i \n",nextPatrol);
          //   if (nextPatrol=<720) {
          //      printf("%.2i:%.2i AM\n",h,m);
          //   } else {
          //      h = h - 12;
          //      printf("%.2i:%.2i PM\n",h,m);
          //   }


           
          // }
  } else{
          for (int i = 0; i <= 4;i++) {
            int nextPatrol = firstPatrol;
            if (i==1) {nextPatrol = firstPatrol + 60;}
            if (i==2) {nextPatrol = firstPatrol +  130;}
            if (i==3) {nextPatrol = firstPatrol +  280;}
            if (i==4) {nextPatrol = firstPatrol +  725;}

            if (nextPatrol >= 1440) {
              nextPatrol -= 1440;
            }

            int h = nextPatrol/60;
            int m = nextPatrol%60;

            printf("%.2i:%.2i\n",h,m);
          } 
  }
}

int main(){
  int h0, m0, o;
  scanf("%i %i %i", &h0, &m0, &o);
  printRonda(h0, m0, o);
  
  return 0;
}