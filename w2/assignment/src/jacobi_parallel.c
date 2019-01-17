#include <stdio.h>
#include <math.h>
#include "datatools.h"
#include <stdlib.h>

void jacobi_parallel(int N, int num_iterations, double **f, double **u, double threshold)
{

	int i, j;
	int k = 0;
	double dist = 100000000000.0;
	double tmp_dist = 0;
	double **u_old = malloc_2d(N + 2, N + 2);

	//grid spacing: 2/(N+1) (x goes from -1 to 1)
	double delta_square = 2.0 / (N + 1) * 2.0 / (N + 1);
#pragma omp parallel
	{
#pragma omp master
		{
			while (dist > threshold && k < num_iterations)
			{
				dist = 0.0;

// #pragma omp for private(i, j, u_old)
#pragma omp task private(i, j, u_old)
				{
					for (i = 0; i <= N + 1; i++)
					{
						for (j = 0; j <= N + 1; j++)
						{
							u_old[i][j] = u[i][j];
						}
					}
				}
#pragma omp task private(i, j, tmp_dist)
				{
					for (i = 1; i <= N; i++)
					{
						tmp_dist = 0;
						for (j = 1; j <= N; j++)
						{
							u[i][j] = 0.25 * (u_old[i - 1][j] + u_old[i + 1][j] + u_old[i][j - 1] + u_old[i][j + 1] + delta_square * f[i][j]);
							tmp_dist += (u[i][j] - u_old[i][j]) * (u[i][j] - u_old[i][j]);
						}
#pragma omp atomic
						dist += tmp_dist;
					}
				}
				dist = (double)sqrt((double)dist);

				k += 1;
			}
		}
	}
	free_2d(u_old);
	printf("Iterations: %d\nDistance: %.18f\n", k, dist);
}