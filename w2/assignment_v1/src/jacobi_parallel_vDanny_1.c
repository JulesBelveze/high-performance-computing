#include <stdio.h>
#include <math.h>
#include "datatools.h"
#include <stdlib.h>

void jacobi_paralleld_one(int n, int num_iterations, double **f, double **u, double threshold)
{
  threshold *= threshold;
  double delta_square = 2.0 / (n + 1) * 2.0 / (n + 1);
  int k, i, j;
  double **temp = NULL;
  double dist = 100000000000.0;
  double **u_old = malloc_2d(n + 2, n + 2);

  for (i = 0; i <= n + 1; i++)
  {
    for (j = 0; j <= n + 1; j++)
    {
      u_old[i][j] = u[i][j];
    }
  }

  #pragma omp parallel default(none) shared(n, u, u_old, num_iterations, threshold, f, delta_square, temp, dist) private(j, i, k)
  {
    for (k = 0; k < num_iterations && dist > threshold; k++)
    {
      #pragma omp barrier
      #pragma omp single
      dist = 0.0;
      #pragma omp for reduction(+ \
             : dist) schedule(dynamic)
      for (i = 1; i <= n; i++)
      {
        for (j = 1; j <= n; j++)
        {
          // printf("Line %d\ti:%d\tj:%d\n", __LINE__,i,j);
          u[i][j] = (u_old[i - 1][j] + u_old[i + 1][j] + u_old[i][j - 1] + u_old[i][j + 1] + delta_square * f[i][j]) * 0.25;
          dist = dist + (u[i][j] - u_old[i][j]) * (u[i][j] - u_old[i][j]);
        }
      }
      // printf("---> DONE: Line %d\n", __LINE__);
      #pragma omp single
      {
        temp = u_old;
        u_old = u;
        u =  temp;
      }
    }
  }
}
