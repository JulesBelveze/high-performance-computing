#include "matmult.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#if defined(__MACH__) && defined(__APPLE__)
#include <Accelerate/Accelerate.h>
#else
#include <cblas.h>
#endif

int MIN_(int a, int b){
    return (a < b) ? a : b;
}

void matmult_nat(int m, int n, int k, double **A, double **B, double **C)
{
    double start, cpu_time_used;
    start = (double) clock();
    // m : number of rows of A
    // k : number of cols of A and number of rows of B
    // n : number of cols of B
    // Matrix C has therefore m rows and n cols
    int i, j, p;
    // computing and printing matrix product
    for (i = 0; i < m; i++)
    {
        for (j = 0; j < n; j++)
        {
            C[i][j] = 0;
            for (p = 0; p < k; p++)
            {
                C[i][j] += A[i][p] * B[p][j];
            }
        }
    }
    cpu_time_used = (((double) clock()) - start) / CLOCKS_PER_SEC;
    printf("%lf\n",cpu_time_used);
}

void matmult_mnk(int m, int n, int k, double **A, double **B, double **C)
{
    double start, cpu_time_used;
    start = (double) clock();
    int i, j, p;

    for (i = 0; i < m; i++)
        for (j = 0; j < n; j++)
                C[i][j] = 0.0;

    for (i = 0; i < m; i++)
    {
        for (j = 0; j < n; j++)
        {
            for (p = 0; p < k; p++)
            {
                C[i][j] += A[i][p] * B[p][j];
            }
        }
    }
    cpu_time_used = (((double) clock()) - start) / CLOCKS_PER_SEC;
    printf("%lf\n",cpu_time_used);
}

void matmult_mkn(int m, int n, int k, double **A, double **B, double **C)
{
    double start, cpu_time_used;
    start = (double) clock();
    int i, j, p;

    for (i = 0; i < m; i++)
        for (j = 0; j < n; j++)
                C[i][j] = 0.0;

    for (i = 0; i < m; i++)
    {
        for (p = 0; p < k; p++)
        {
            for (j = 0; j < n; j++)
            {
                C[i][j] += A[i][p] * B[p][j];
            }
        }
    }
    cpu_time_used = (((double) clock()) - start) / CLOCKS_PER_SEC;
    printf("%lf\n",cpu_time_used);
}

void matmult_nmk(int m, int n, int k, double **A, double **B, double **C)
{
    double start, cpu_time_used;
    start = (double) clock();
    int i, j, p;

    for (i = 0; i < m; i++)
        for (j = 0; j < n; j++)
                C[i][j] = 0.0;

    for (j = 0; j < n; j++)
    {
        for (i = 0; i < m; i++)
        {
            for (p = 0; p < k; p++)
            {
                C[i][j] += A[i][p] * B[p][j];
            }
        }
    }
    cpu_time_used = (((double) clock()) - start) / CLOCKS_PER_SEC;
    printf("%lf\n",cpu_time_used);
}
void matmult_nkm(int m, int n, int k, double **A, double **B, double **C)
{
    double start, cpu_time_used;
    start = (double) clock();
    int i, j, p;

    for (i = 0; i < m; i++)
        for (j = 0; j < n; j++)
                C[i][j] = 0.0;

    for (j = 0; j < n; j++)
    {
        for (p = 0; p < k; p++)
        {
            for (i = 0; i < m; i++)
            {
                C[i][j] += A[i][p] * B[p][j];
            }
        }
    }
    cpu_time_used = (((double) clock()) - start) / CLOCKS_PER_SEC;
    printf("%lf\n",cpu_time_used);
}

void matmult_kmn(int m, int n, int k, double **A, double **B, double **C)
{
    double start, cpu_time_used;
    start = (double) clock();
    int i, j, p;

    for (i = 0; i < m; i++)
        for (j = 0; j < n; j++)
                C[i][j] = 0.0;

    for (p = 0; p < k; p++)
    {
        for (i = 0; i < m; i++)
        {
            for (j = 0; j < n; j++)
            {
                C[i][j] += A[i][p] * B[p][j];
            }
        }
    }
    cpu_time_used = (((double) clock()) - start) / CLOCKS_PER_SEC;
    printf("%lf\n",cpu_time_used);
}
void matmult_knm(int m, int n, int k, double **A, double **B, double **C)
{
    double start, cpu_time_used;
    start = (double) clock();
    int i, j, p;

    for (i = 0; i < m; i++)
        for (j = 0; j < n; j++)
                C[i][j] = 0.0;

    for (p = 0; p < k; p++)
    {
        for (j = 0; j < n; j++)
        {
            for (i = 0; i < m; i++)
            {
                C[i][j] += A[i][p] * B[p][j];
            }
        }
    }
    cpu_time_used = (((double) clock()) - start) / CLOCKS_PER_SEC;
    printf("%lf\n",cpu_time_used);
}

void matmult_lib(int m, int n, int k, double **A, double **B, double **C)
{
    double start, cpu_time_used;
    start = (double) clock();
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m, n, k, 1.0, A[0], k, B[0], n, 0.0, C[0], n);
    cpu_time_used = (((double) clock()) - start) / CLOCKS_PER_SEC;
    printf("%lf\n",cpu_time_used);
}

void matmult_blk(int m, int n, int k, double **A, double **B, double **C, int bs)
{
    double start, cpu_time_used;
    start = (double) clock();
    // m : number of rows of A
    // k : number of cols of A and number of rows of B
    // n : number of cols of B
    // Matrix C has therefore m rows and n cols
    int i, j, p, i0, j0, p0;
    int min_i, min_j, min_p;

    bs = (bs <= 0) ? 1 : bs;

    for (i = 0; i < m*n; i++){
        C[0][i] = 0.0;
    }

    for (i = 0; i < m; i += bs){
        for (j = 0; j < n; j += bs){
            for (p = 0; p < k; p += bs){
                min_i = MIN_(m, i+bs);
                min_j = MIN_(n, j+bs);
                min_p = MIN_(k, p+bs);
                for (i0 = i; i0 < min_i; i0++){
                    for (p0 = p; p0 < min_p; p0++){
                        for (j0 = j; j0 < min_j; j0++){
                            C[i0][j0] += A[i0][p0] * B[p0][j0];
                        }
                    }
                }
            }
        }
    }
    cpu_time_used = (((double) clock()) - start) / CLOCKS_PER_SEC;
    printf("%lf\n",cpu_time_used);
}

// // TODO: This test can be deleted if plots are working
// int main()
// {
//     double start, cpu_time_used;
//     start = (double) clock();
//     for (int i = 0; i < 100; i++)
//     {
//         for (int j = 0; j < i*i; j++)
//         {
//             // cpu_time_used = clock();
//         }
//     }
//     // cpu_time_used = (((double) clock()) / CLOCKS_PER_SEC) - start;
//     cpu_time_used = (((double) clock()) - start) / CLOCKS_PER_SEC;
//     printf("%lf\n",cpu_time_used);
// }
