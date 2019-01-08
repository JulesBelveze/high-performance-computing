#include <stdio.h>
#include <stdlib.h>
#include <time.h>
// matrix_add

void matrix_add(int row, int col, int MatrixA[row][col],int MatrixB[row][col],int MatrixC[row][col])
{
  for(int i = 0; i < row; i++)
  {
    for(int j = 0; j < col; j++)
    {
        MatrixC[i][j] = MatrixA[i][j] + MatrixB[i][j];
        //printf("%d ", MatrixC[i][j]);
    }
    // printf("\n");
  }
}

void generate_matrix(int row, int col, int Matrix[row][col])
{
  for(int i = 0; i < row; i++)
  {
    for(int j = 0; j < col; j++)
    {
        Matrix[i][j] = rand()%10;
        //Matrix[i][j] = rand();
    }
  }
}

void generate_vector(int col, int outvector[col])
{
  for(int i = 0; i < col; i++)
  {
    outvector[i] = rand() % 10;
    // outvector[i] = rand();
  }
}

void print_vector(int col, int invector[col])
{
  for(int j = 0; j < col; j++)
  {
      printf("%d ", invector[j]);
  }
  printf("\n");
}

void print_matrix(int row, int col, int Matrix[row][col])
{
  for(int i = 0; i < row; i++)
  {
    for(int j = 0; j < col; j++)
    {
        printf("%d ", Matrix[i][j]);
    }
    printf("\n");
  }
}

void timerun_matrix_matrix_add()
{
  for(int i = 2; i<1000;i++){
    int timesum = 0;
    int repetitions = 10;
    for(int rep = 0; rep < repetitions; rep++){
      int row = i;
      int col = i;
      int Matrix[row][col];
      int Matrix_B[row][col];
      generate_matrix(row,col,Matrix);
      generate_matrix(row,col,Matrix_B);

      clock_t start, end;
      float cpu_time_used;
      start = clock();

      // printf("Matrix 1\n");
      // print_matrix(row,col,Matrix);
      // printf("Matrix 2\n");
      // print_matrix(row,col,Matrix_B);
      // printf("Matrix 3\n");
      int Matrix_C[row][col];
      matrix_add(row, col,Matrix,Matrix_B,Matrix_C);
      // print_matrix(row,col,Matrix_C);

      end = clock();
      cpu_time_used = ((float) (end - start));/// CLOCKS_PER_SEC;
      // printf("N: %d \tTime: %lf\n",i,cpu_time_used);
      printf("O");
      timesum += cpu_time_used;
    }
    float timeavg = timesum/repetitions;

    FILE * fp;
    fp = fopen ("test.txt","a");
    printf("N: %d T: %f\n",i,timeavg);
    fprintf(fp, "%d, %f\n",i,timeavg);
    fclose (fp);

    printf("N: %d T: %f\n",i,timeavg);
  }
}

void matrix_vector_mult(int row, int col, int inmatrix[row][col], int invector[col], int outmatrix[row][col])
{
  for(int i = 0; i < row; i++)
  {
    for(int j = 0; j < col; j++)
    {
      printf("----- %d * %d\n",inmatrix[i][j],invector[j]);
      outmatrix[i][j]=inmatrix[i][j]*invector[j];
    }
  }
}

void mat_mat_mult(int rowA, int colA, int mA[rowA][colA], int rowB, int colB, int mB[rowB][colB],int mC[rowA][rowB])
{
  int c,d,k, sum = 0;

  //int mC[rowA][colB];

  for (c = 0; c < rowA; c++)
  {
    for (d = 0; d < colB; d++)
    {
      for (k = 0; k < rowB; k++) {
        sum = sum + mA[c][k]*mB[k][d];
      }
      mC[c][d] = sum;
      sum = 0;
    }
  }
  //print_matrix(rowA,colB,mC);
}

void demo_vector()
{
  int bsize = 7;
  int b[bsize];
  generate_vector(bsize,b);
  print_vector(bsize,b);
}

void demo_mat_vec_mult()
{
  int dim = 3;
  int m[dim][dim];
  generate_matrix(dim,dim,m);
  print_matrix(dim,dim,m);
  printf("-----\n");
  int v[dim];
  generate_vector(dim,v);
  print_vector(dim,v);
  printf("-----\n");

  int out_m[dim][dim];
  matrix_vector_mult(dim,dim,m,v,out_m);
  print_matrix(dim,dim,out_m);
}

void demo_mat_mat_mult()
{
  const int rA = 3;
  const int cA = 2;
  // int mA[rA][cA];
  // generate_matrix(rA,cA,mA);
  int mA[rA][cA] = {
    {4,8},
    {0,2},
    {1,6}
  };

  const int rB = 2;
  const int cB = 2;
  // int mB[rB][cB];
  // generate_matrix(rB,cB,mB);
  int mB[rA][cA] = {
    {5,2},
    {9,4}
  };

  printf("-- Matix A --\n");
  printf("r:%d, c:%d\n",rA,cA);
  print_matrix(rA,cA,mA);
  printf("-- Matix B --\n");
  printf("r:%d, c:%d\n",rB,cB);
  print_matrix(rB,cB,mB);
  printf("-- Matix C --\n");
  printf("r:%d, c:%d\n",rA,cB);

  int mC[rA][cB];
  mat_mat_mult(rA,cA,mA,rB,cB,mB,mC);
  print_matrix(rA,cB,mC);
}

void timerun_matrix_gen()
{
  char filename[] = "matrix_generate.txt";
  FILE * fp1;
  fp1 = fopen(filename,"w");
  fprintf(fp1, "");
  // fp1.close();

  for(int i = 2; i<1000;i++){
    int timesum = 0;
    int repetitions = 10;
    for(int rep = 0; rep < repetitions; rep++){
      // preparation stuff
      int mA[i][i];


      clock_t start, end;
      float cpu_time_used;
      start = clock();

      // stuff to time
      generate_matrix(i,i,mA);

      end = clock();
      cpu_time_used = ((float) (end - start));/// CLOCKS_PER_SEC;
      timesum += cpu_time_used;
    }
    float timeavg = timesum/repetitions;

    FILE * fp;
    fp = fopen (filename,"a");
    printf("N: %d T: %f\n",i,timeavg);
    fprintf(fp, "%d, %f\n",i,timeavg);
    fclose(fp);
    printf("N: %d T: %f\n",i,timeavg);
  }
}

void timerun_mat_mat_mult()
{
  char filename[] = "matrix_matrix_mult.txt";
  FILE * fp1;
  fp1 = fopen(filename,"w");
  fprintf(fp1, "");
  // fp1.close();

  for(int i = 2; i<200;i++){
    int timesum = 0;
    int repetitions = 10;
    for(int rep = 0; rep < repetitions; rep++){
      // preparation stuff
      int n = i;
      int mA[n][n];
      int mB[n][n];
      int mC[n][n];
      generate_matrix(n,n,mB);
      generate_matrix(n,n,mA);

      clock_t start, end;
      float cpu_time_used;
      start = clock();

      // stuff to time
      mat_mat_mult(n,n,mA,n,n,mB,mC);

      end = clock();
      cpu_time_used = ((float) (end - start));/// CLOCKS_PER_SEC;
      printf("O");
      timesum += cpu_time_used;
    }
    float timeavg = timesum/repetitions;
    FILE * fp;
    fp = fopen (filename,"a");
    printf("N: %d T: %f\n",i,timeavg);
    fprintf(fp, "%d, %f\n",i,timeavg);
    fclose(fp);
    printf("N: %d T: %f\n",i,timeavg);
  }
}

int main()
{
  return 0;
}
