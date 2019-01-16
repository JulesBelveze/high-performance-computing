#include <stdio.h>
#include <math.h>
#include "datatools.h"
#include <stdlib.h>

void jacobi(int N, int num_iterations, double **f, double **u, double threshold)
{

	int i, j;
	int k = 0;
	double dist = 100000000000.0;
	double norm;
	double **u_old = malloc_2d(N + 2, N + 2);

	//grid spacing: 2/(N+1) (x goes from -1 to 1)
	double delta = 2 / (N + 1);
	while (dist > threshold && k < num_iterations)
	{
		dist = 0.0;
		norm = 0.0;
		u_old = u;
		for (i = 1; i <= N; i++)
		{
			for (j = 1; j <= N; j++)
			{
				u[i][j] = 0.25 * (u_old[i - 1][j] + u_old[i + 1][j] + u_old[i][j - 1] + u_old[i][j + 1] + delta * delta * f[i][j]);
				printf("%f \n", u[i][j] - u_old[i][j]);
				dist += (u[i][j] - u_old[i][j]) * (u[i][j] - u_old[i][j]);
				norm += u[i][j] * u[i][j];
			}
		}
		dist = dist / norm;

		k += 1;
	}
	free_2d(u_old);
	printf("Iterations: %d\n distance: %.8f\n", k, dist);
}
