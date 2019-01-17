#include <stdlib.h>
#include <stdio.h>
#include <time.h>

#include "jacobi_parallel.h"
#include "jacobi_parallel_naive.h"

#include "datatools.h"
#include "jacobi.h"
#include "gauss.h"

void print_matrix(int n, double **Matrix)
{
	for (int j = 0; j < n; j++)
	{
		for (int i = 0; i < n; i++)
		{
			printf("%.2lf ", Matrix[i][j]);
		}
		printf("\n");
	}
}

int main(int argc, char *argv[])
{
	int N = 100;
	int poisson = 0;
	double threshold = 1e-10;
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
		printf("Jacobi\n");
		printf("N: %d\n", N);
		jacobi(N, num_iterations, f, u, threshold);
	}
	else if (poisson == 2)
	{
		printf("Jacobi parallel naive\n");
		printf("N: %d\n", N);
		jacobi_parallel_naive(N, num_iterations, f, u, threshold);
	}
	else if (poisson == 3)
	{
		printf("Jacobi parallel\n");
		printf("N: %d\n", N);
		jacobi_parallel(N, num_iterations, f, u, threshold);
	}
	else
	{
		printf("Gausss method \n");
		printf("N: %d\n", N);
		gauss(N, num_iterations, f, u, threshold);
	}
	print_matrix(N+2,u);
	free_2d(u);
	free_2d(f);
	return 0;
}
