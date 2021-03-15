#include <stdio.h>

int main()
{
  int a, b, c;
  printf ("Digite A:");
  scanf("%d", &a);
  printf ("Digite B:");
  scanf("%d", &b);
  printf ("Digite C:");
  scanf("%d", &c);
  
  if (a+b == c | a+c== b  | c+b==a){
    printf("Um dos números é a soma dos outros dois");
  } else {
    printf("Nenhum dos números é a soma dos outros dois");
  }
  
  return 0;
}

