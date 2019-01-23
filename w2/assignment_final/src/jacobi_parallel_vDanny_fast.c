#include <stdio.h>
#include <math.h>
#include "datatools.h"
#include <stdlib.h>

void jacobi_parallel_d_fast(int n, int num_iterations, double **f, double **u, double threshold)
{
  threshold *= threshold;
  double delta_square = 2.0 / (n + 1) * 2.0 / (n + 1);
  int k = 0, i, j;
  double **temp = NULL;
  double c_dist = 100000000000.0;
  double dist = 100000000000.0;
  double **u_old = malloc_2d(n + 2, n + 2);
  double **u_new = malloc_2d(n + 2, n + 2);

#pragma omp parallel default(none) shared(n, u, u_old, num_iterations, threshold, f, delta_square, temp, c_dist, k, u_new) private(j, i) reduction(+ \
                                                                                                                                                   : dist)
  {
#pragma omp for private(i, j) schedule(dynamic, 50)
    for (i = 0; i <= n + 1; i++)
    {
      for (j = 0; j <= n + 1; j++)
      {
        u_old[i][j] = u[i][j];
        u_new[i][j] = u[i][j];
      }
    }

    while (k < num_iterations && c_dist > threshold)
    {
#pragma omp single
      dist = 0.0;
#pragma omp for private(i, j) nowait schedule(dynamic, 50)
      for (i = 1; i <= n; i++)
      {
        for (j = 1; j <= n; j++)
        {
          u_new[i][j] = 0.25 * (u_old[i - 1][j] + u_old[i + 1][j] + u_old[i][j - 1] + u_old[i][j + 1] + delta_square * f[i][j]);
          dist = dist + (u_new[i][j] - u_old[i][j]) * (u_new[i][j] - u_old[i][j]);
        }
      }

      k += 1;
#pragma omp single
      {
        c_dist = dist;
        temp = u_old;
        u_old = u_new;
        u_new = temp;
      }
    }
  }
}
