#include <stdio.h>

int main()
{
  int n;
  scanf("%d",&n);
  if (n % 3 == 0 && n % 5 != 0 && n != 0){
    printf("Resposta: 1");
  } else {
        printf("Resposta: 0");
    }
  return 0;
}
