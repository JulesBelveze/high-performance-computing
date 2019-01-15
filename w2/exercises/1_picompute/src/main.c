#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h>

void timestamp()
{
    time_t ltime; /* calendar time */
    ltime=time(NULL); /* get current cal time */
    printf("%s",asctime( localtime(&ltime) ) );
}

int main()
{
  float sum = 0;
  timestamp();
  int n = 100000;
  printf("n:\t%d\n", n);
  int i;
  #pragma omp parallel for default(none) \
              shared(n) private(i) reduction(+:sum)
  for(i = 1; i <= n; i++)
  {
    // float fi = i;
    sum += 4 / (1 + ((i-0.5)/n)*((i-0.5)/n));
  }
  sum = sum / n;
  // printf("pi:\t%.4f\n", sum);
  printf("pi:\t%f\n", sum);

  return 0;
}
