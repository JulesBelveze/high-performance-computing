#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <omp.h>

#include "datatools.h"		
#include "jacobi.h"		
#include "gauss.h"



int
main(int argc, char *argv[]){
	int N, num_iterations, poisson;
	double threshold;
	double **u_new, **u_old, **f;

	if (argc == 2){
		poisson = atoi(argv[1]);
		N = 100;
		num_iterations = 10000;
		threshold = 1e-10;
	}
	else if (argc == 3){
		poisson = atoi(argv[1]);
		N = atoi(argv[2]);
		num_iterations = 10000;
		threshold = 1e-10;
	}
	else if (argc == 4){
		poisson = atoi(argv[1]);
		N = atoi(argv[2]);
		num_iterations = atoi(argv[3]);
		threshold = 1e-10;
	}
	else if (argc == 5){
		poisson = atoi(argv[1]);
		N = atoi(argv[2]);
		num_iterations = atoi(argv[3]);
		threshold = atoi(argv[4]);
	}
	else {
		poisson = 0;
		N = 100;
		num_iterations = 10000;
		threshold = 1e-10;
	}

	u_new = malloc_2d(N+2, N+2);
	u_old = malloc_2d(N+2, N+2);
	f = malloc_2d(N+2, N+2);
	if (u_new == NULL || u_old == NULL | f == NULL) {
	    printf(stderr, "Memory allocation error...\n");
	    exit(EXIT_FAILURE);
	}

	
	init_data(N,u_new,u_old,f);
	if (poisson == 0) {
		jacobi(N,num_iterations,f, u_new, u_old, threshold);
	}
	else {
		gauss_seidel(N, num_iterations,f,u_new,threshold);
	}
        free_2d(u_new);
	free_2d(u_old);
	free_2d(f);
	return 0;
}

