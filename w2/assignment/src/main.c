#include <stdlib.h>
#include <stdio.h>
#include <time.h>

#include "jacobi_parallel_v1.h"
#include "jacobi_parallel_naive.h"
#include "jacobi_parallel_v2.h"
#include "jacobi_parallel_v3.h"
#include "jacobi_parallel_vDanny.h"
#include "jacobi_parallel_vDanny_1.h"

#include "jacobi_parallel_vDanny_fast.h"

#include "datatools.h"
#include "jacobi.h"
#include "gauss.h"

void print_matrix(int n, double **Matrix)
{
	int j, i;
	for (j = 0; j < n; j++)
	{
		for (i = 0; i < n; i++)
		{
			printf("%.2lf ", Matrix[i][j]);
		}
		printf("\n");
	}
}

int main(int argc, char *argv[])
{
	int N = 1000;
	int poisson = 0;
	double threshold = 1e-3;
	double **u, **f;
	int num_iterations = 10000;

	if (argc == 2)
	{
		poisson = atoi(argv[1]);
	}
	else if (argc == 3)
	{
		poisson = atoi(argv[1]);
		N = atoi(argv[2]);
	}
	else if (argc == 4)
	{
		poisson = atoi(argv[1]);
		N = atoi(argv[2]);
		num_iterations = atoi(argv[3]);
	}
	else if (argc == 5)
	{
		poisson = atoi(argv[1]);
		N = atoi(argv[2]);
		num_iterations = atoi(argv[3]);
		threshold = atoi(argv[4]);
	}

	u = malloc_2d(N + 2, N + 2);
	f = malloc_2d(N + 2, N + 2);
	if (u == NULL || f == NULL)
	{
		printf("Memory allocation error...\n");
		exit(EXIT_FAILURE);
	}

	// printf("Mode:%d\nN:%d\nk:%d\nThresh:%fl\n",poisson,N,num_iterations,threshold);

	init_data(N, u, f);
	// printf("f:\n");
	// print_matrix(N + 2, f);
	// printf("u:\n");
	// print_matrix(N + 2, u);

	if (poisson == 0)
	{
		// printf("Jacobi\n");
		// printf("N: %d\n", N);
		jacobi(N, num_iterations, f, u, threshold);
	}
	else if (poisson == 2)
	{
		// printf("Jacobi parallel naive\n");
		// printf("N: %d\n", N);
		jacobi_parallel_naive(N, num_iterations, f, u, threshold);
	}
	else if (poisson == 3)
	{
		// printf("Jacobi parallel\n");
		// printf("N: %d\n", N);
		jacobi_parallel_1(N, num_iterations, f, u, threshold);
	}
	else if (poisson == 4)
	{
		// printf("Jacobi parallel\n");
		// printf("N: %d\n", N);
		jacobi_parallel_2(N, num_iterations, f, u, threshold);
	}
	else if (poisson == 5)
	{
		// printf("Jacobi parallel\n");
		// printf("N: %d\n", N);
		jacobi_parallel_3(N, num_iterations, f, u, threshold);
	}
	else if (poisson == 6)
	{
		// DANNY V_2
		jacobi_parallel_d(N, num_iterations, f, u, threshold);
	}
	else if (poisson == 7)
	{
		// DANNY V_1
		jacobi_paralleld_one(N, num_iterations, f, u, threshold);
	}
	else if (poisson == 8)
	{
		// DANNY V_1
		jacobi_parallel_d_fast(N, num_iterations, f, u, threshold);
	}
	else
	{
		// printf("Gausss method \n");
		// printf("N: %d\n", N);
		gauss(N, num_iterations, f, u, threshold);
	}
	// print_matrix(N + 2, u);
	free_2d(u);
	free_2d(f);
	return 0;
}
