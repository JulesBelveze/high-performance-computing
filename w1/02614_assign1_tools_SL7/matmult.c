#include "matmult.h"
#include "stdio.h"

void matmult_nat(int m, int n, int k, double **A, double **B, double **C)
{
    // m : number of rows of A
    // k : number of cols of A and number of rows of B
    // n : number of cols of B
    // Matrix C has therefore m rows and n cols

    int i, j, p;

    // feeding matrix A
    for (i = 0; i < m; i++)
    {
        for (j = 0; j < k; j++)
        {
            A[i][j] = 2.0;
        }
    }

    // feeding matrix B
    for (i = 0; i < k; i++)
    {
        for (j = 0; j < n; j++)
        {
            B[i][j] = 2.0;
        }
    }

    // computing and printing matrix product
    for (i = 0; i < m; i++)
    {
        for (j = 0; j < n; j++)
        {
            for (p = 0; p < k; p++)
            {
                C[i][j] += A[i][p] * B[p][j];
            }
            printf("%.3f  ", C[i][j]);
        }
        printf("\n");
    }
}

void matmult_blk(int m, int n, int k, double **A, double **B, double **C, int bs)
{
}
