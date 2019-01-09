#include <stdio.h>
#include <stdlib.h>
#include <time.h>
// #if defined(__MACH__) && defined(__APPLE__)
// #include <Accelerate/Accelerate.h>
// #else
// #include <cblas.h>
// #endif

void print_matrix(int row, int col, double m[row][col])
{
  for(int i = 0; i < row; i++)
  {
    for(int j = 0; j < col; j++)
    {
        printf("%f ", m[i][j]);
    }
    printf("\n");
  }
}


void generate_matrix(int row, int col, int m[row][col])
{
  for(int i = 0; i < row; i++)
  {
    for(int j = 0; j < col; j++)
    {
      m[i][j] = rand()%10;
      //m[i][j] = (double)rand();
    }
  }
}

void generate_zero_matrix(int row, int col, int m[row][col])
{
  for(int i = 0; i < row; i++)
  {
    for(int j = 0; j < col; j++)
    {
      m[i][j] = 0;
      //m[i][j] = (double)rand();
    }
  }
}

void matmult_nat(int m, int n, int k, double **A, double **B, double **C)
// void matmult_nat(int m, int n, int k, double A[m][k], double B[k][n], double C[m][n])
{
  int i, j, p;
  for (i = 0; i < m; i++)
  {
    for (j = 0; j < n; j++)
    {
      C[i][j] = 0;
      for (p = 0; p < k; p++)
      {
        // printf("%f x %f = %f",A[i][p],B[p][j],C[i][j]);
        C[i][j] += A[i][p] * B[p][j];
        // printf("%f\n",A[i][j]);
      }
    }
  }
}

int main()
{
  int m = 3;
  int n = 3;
  int k = 3;

  double (**A)[k] = malloc( sizeof(double[m][k]));

  double (**B)[n] = malloc( sizeof(double[k][n]));

  double (**C)[n] = malloc( sizeof(double[m][n]));

  generate_matrix(m,k,A);
  print_matrix(m,k,A);


  // double A[m][k];
  // double B[k][n];
  // double C[m][n];
  // double C[3][3] = {
  //   {0, 0, 0},
  //   {0, 0, 0},
  //   {0, 0, 0}
  // };
  //
  // printf("--Matrix A (%dx%d):\n",m,k);
  // // generate_matrix(m,k,A);
  // print_matrix(m,k,A);
  //
  // printf("--Matrix B (%dx%d):\n",k,n);
  // // generate_matrix(k,n,B);
  // print_matrix(k,n,B);

  // printf("--Matrix C (%dx%d) filled w Zeros:\n",m,n);
  // generate_zero_matrix(m,n,C);
  // print_matrix(m,n,C);

  // printf("--Matrix C (%dx%d) via matmult_nat:\n",m,n);
  // matmult_nat(m,n,k,A,B,C);
  // print_matrix(m,n,C);
}
