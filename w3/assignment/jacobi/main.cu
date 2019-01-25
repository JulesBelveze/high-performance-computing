#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <omp.h>
#include <string.h>

#include "datatools.h"
#include "jacobi_library.h"

int main(int argc, char *argv[])
{

    int n, num_iterations;
    double ts, te;
    double *u, *u_old, *f, *u_new;
    char type[4];

    if (argc == 2)
    {
        strcpy(type, argv[1]);
        n = 100;
        num_iterations = 10000;
    }
    else if (argc == 3)
    {
        strcpy(type, argv[1]);
        n = atoi(argv[2]);
        num_iterations = 10000;
    }
    else if (argc == 4)
    {
        strcpy(type, argv[1]);
        n = atoi(argv[2]);
        num_iterations = atoi(argv[3]);
    }
    else
    {
        strcpy(type, "cpu");
        n = 100;
        num_iterations = 10000;
    }

    /* Allocate memory*/
    u = (double *)malloc((n + 2) * (n + 2) * sizeof(double));
    u_old = (double *)malloc((n + 2) * (n + 2) * sizeof(double));
    u_new = (double *)malloc((n + 2) * (n + 2) * sizeof(double));
    f = (double *)malloc((n + 2) * (n + 2) * sizeof(double));

    if (u == NULL || u_old == NULL | f == NULL | u_new == NULL)
    {
        // fprintf("Memory allocation error...\n");
        exit(EXIT_FAILURE);
    }

    /* Initialize data */
    init_data(n, u, f);

    /* Call the function */
    if (strcmp(type, "cpu") == 0)
    {
        jacobi_cpu(n, num_iterations, f, u);
    }
    else if (strcmp(type, "gpu1") == 0)
    {
        jacobi_gpu1(n, num_iterations, f, u);
    }
    else if (strcmp(type, "gpu2") == 0)
    {
        jacobi_gpu2(n, num_iterations, f, u);
    }
    else if (strcmp(type, "gpu3") == 0)
    {
        jacobi_gpu3(n, num_iterations, f, u);
    }

    /* Free memory */
    free(u);
    free(u_old);
    free(u_new);
    free(f);

    return (0);
}
