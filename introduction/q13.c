#include <stdio.h>

int main(){
  int a, b, c;
  float d;
  scanf("%d",&a);
  scanf("%d",&b);
  scanf("%d",&c);

  if (a+b == c | a+c == b | c+b == a){
    printf("Resposta: 1");
  } else{
    printf("Resposta: 0");
  }
  return 0;
}