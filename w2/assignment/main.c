#include <stdlib.h>
#include <stdio.h>
#include <time.h>
// #include <omp.h>

#include "datatools.h"
#include "jacobi.h"
#include "gauss.h"

void print_matrix(int n, double **Matrix)
{
  for(int j = 0; j < n; j++)
  {
    for(int i = 0; i < n; i++)
    {
        printf("%.2lf ", Matrix[i][j]);
    }
    printf("\n");
  }
}

int main(int argc, char *argv[])
{
	int N, num_iterations, poisson;
	double threshold;
	double **u, **f;

	if (argc == 2)
	{
		poisson = atoi(argv[1]);
		N = 100;
		num_iterations = 10000;
		threshold = 1e-10;
	}
	else if (argc == 3)
	{
		poisson = atoi(argv[1]);
		N = atoi(argv[2]);
		num_iterations = 10000;
		threshold = 1e-10;
	}
	else if (argc == 4)
	{
		poisson = atoi(argv[1]);
		N = atoi(argv[2]);
		num_iterations = atoi(argv[3]);
		threshold = 1e-10;
	}
	else if (argc == 5)
	{
		poisson = atoi(argv[1]);
		N = atoi(argv[2]);
		num_iterations = atoi(argv[3]);
		threshold = atoi(argv[4]);
	}
	else
	{
		poisson = 0;
		N = 10;
		num_iterations = 10000;
		threshold = 1e-10;
	}

	u = malloc_2d(N + 2, N + 2);
	f = malloc_2d(N + 2, N + 2);
	if (u == NULL | f == NULL)
	{
		printf(stderr, "Memory allocation error...\n");
		exit(EXIT_FAILURE);
	}

	init_data(N, u, f);
	printf("f:\n");
	print_matrix(N+2,f);
	printf("u:\n");
  print_matrix(N+2,u);


	if (poisson == 0)
	{
		jacobi(N, num_iterations, f, u, threshold);
	}
	else
	{
		gauss(N, num_iterations, f, u, threshold);
	}
	// free_2d(u);
	// free_2d(f);
	return 0;
}
