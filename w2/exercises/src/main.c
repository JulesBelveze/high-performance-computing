#include <stdio.h>
#include <stdlib.h>

int main()
{
  float sum = 0;
  printf("Hello\n");
  float n = 1e5;
  printf("n:\t%f\n", n);
  for(float i = 1; i <= n; i++)
  {
    sum += 4 / (1 + ((i-0.5)/n)*((i-0.5)/n));
  }
  sum = sum / n;
  // printf("pi:\t%.4f\n", sum);
  printf("pi:\t%f\n", sum);

  return 0;
}
