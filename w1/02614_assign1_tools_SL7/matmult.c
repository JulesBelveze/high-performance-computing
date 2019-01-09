#include "matmult.h"
#include "stdio.h"
#if defined(__MACH__) && defined(__APPLE__)
#include <Accelerate/Accelerate.h>
#else
#include <cblas.h>
#endif

void matmult_nat(int m, int n, int k, double **A, double **B, double **C)
{
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
      // printf("%.3f  ", C[i][j]);
    }
    // printf("\n");
  }
}

void matmult_mnk(int m, int n, int k, double **A, double **B, double **C)
{
  int i, j, p;
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
}

void matmult_mkn(int m, int n, int k, double **A, double **B, double **C)
{
  int i, j, p;
  for (i = 0; i < m; i++)
  {
    C[i][j] = 0;
    for (p = 0; p < k; p++)
    {
      for (j = 0; j < n; j++)
      {
        C[i][j] += A[i][p] * B[p][j];
      }
    }
  }
}

// void matmult_nmk(int m, int n, int k, double **A, double **B, double **C);
// void matmult_nkm(int m, int n, int k, double **A, double **B, double **C);
//
// void matmult_kmn(int m, int n, int k, double **A, double **B, double **C);
// void matmult_knm(int m, int n, int k, double **A, double **B, double **C);

void matmult_lib(int m, int n, int k, double **A, double **B, double **C)
{
  cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m, n, k, 1.0, A[0], k, B[0], n, 0.0, C[0], n);
}

void matmult_blk(int m, int n, int k, double **A, double **B, double **C, int bs)
{
}
