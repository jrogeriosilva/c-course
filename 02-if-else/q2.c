#include <stdio.h>

int main()
{
  int a, b, c;
  scanf("%d", &a);
  scanf("%d", &b);
  printf ("A:  %d \n",a);
  printf ("B: %d \n",b);

  c = a;
  a = b;
  b = c;
  
  
  printf ("A:  %d \n",a);
  printf ("B: %d \n",b);

  return 0;
}

