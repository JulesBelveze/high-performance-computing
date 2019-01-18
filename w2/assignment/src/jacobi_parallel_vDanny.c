#include <stdio.h>
#include <math.h>
#include "datatools.h"
#include <stdlib.h>

void jacobi_parallel_d(int n, int num_iterations, double **f, double **u, double threshold)
{
  threshold *= threshold;
  double delta_square = 2.0 / (n + 1) * 2.0 / (n + 1);
  int k=0, i, j;
  double **temp = NULL;
  double c_dist = 100000000000.0;
  double dist = 100000000000.0;
  double **u_old = malloc_2d(n + 2, n + 2);

  #pragma omp parallel for private(i, j)
  for (i = 0; i <= n + 1; i++)
  {
    for (j = 0; j <= n + 1; j++)
    {
      u_old[i][j] = u[i][j];
    }
  }

   #pragma omp parallel default(none) firstprivate(k) shared(n, u, u_old, num_iterations, threshold, f, delta_square, temp, c_dist) private(j, i) reduction(+ \
          : dist)
  {

    while(k < num_iterations && c_dist > threshold)
    {
      #pragma omp single
      dist = 0.0;
      #pragma omp for
      for (i = 1; i <= n; i++)
      {
        for (j = 1; j <= n; j++)
        {
          u[i][j] = 0.25* (u_old[i - 1][j] + u_old[i + 1][j] + u_old[i][j - 1] + u_old[i][j + 1] + delta_square * f[i][j]);
          dist = dist + (u[i][j] - u_old[i][j]) * (u[i][j] - u_old[i][j]);
        }
      }

      k += 1;
      #pragma omp single
      {
        c_dist = dist;
        temp = u_old;
        u_old = u;
        u =  temp;
      }
    }
  }
}
