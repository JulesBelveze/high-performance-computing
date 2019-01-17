#include <stdio.h>
#include <math.h>
#include "datatools.h"
#include <stdlib.h>

void calc(int N, int num_iterations, double **f, double **u, double threshold)
{
	int i, j;
	int k = 0;
	double dist = 100000000000.0;
	double **u_old = malloc_2d(N + 2, N + 2);

	double **temp = NULL;

#pragma omp for private(i, j)
	for (i = 0; i <= N + 1; i++)
	{
		for (j = 0; j <= N + 1; j++)
		{
			u_old[i][j] = u[i][j];
		}
	}

	//grid spacing: 2/(N+1) (x goes from -1 to 1)
	double delta_square = 2.0 / (N + 1) * 2.0 / (N + 1);

	while (dist > threshold && k < num_iterations)
	{
		dist = 0.0;
		double tmp_dist = 0.0;
		// reduction(+
		// : dist) // schedule(dynamic)
#pragma omp for private(i, j) reduction(+ \
																				: tmp_dist)
		for (i = 1; i <= N; i++)
		{
			for (j = 1; j <= N; j++)
			{
				u[i][j] = 0.25 * (u_old[i - 1][j] + u_old[i + 1][j] + u_old[i][j - 1] + u_old[i][j + 1] + delta_square * f[i][j]);
				tmp_dist += (u[i][j] - u_old[i][j]) * (u[i][j] - u_old[i][j]);
			}
			// #pragma omp atomic
			dist += tmp_dist;
		}
		// memory address movearound thing idea...
		temp = u;
		u = u_old;
		u_old = temp;
		k += 1;
	}
}

void jacobi_parallel_2(int N, int num_iterations, double **f, double **u, double threshold)
{
	threshold *= threshold;

#pragma omp parallel
	{
		calc(N, num_iterations, f, u, threshold);
	}
	// free_2d(u_old);
	// printf("Iterations: %d\nDistance: %.18f\n", k, dist);
}