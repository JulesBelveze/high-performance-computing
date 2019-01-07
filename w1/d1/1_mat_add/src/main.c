#include <stdio.h>
#include <stdlib.h>
#include <time.h>


void matrix_add_debug(int row, int col, int MatrixA[row][col],int MatrixB[row][col])
{
  printf("rows: %d\n", row);
  printf("cols: %d \n", col);
  printf("Matrix A:\n");
  int MatrixC[col][row];
  for(int i = 0; i < row; i++)
  {
    for(int j = 0; j < col; j++)
    {
        printf("%d ", MatrixA[i][j]);
    }
    printf("\n");
  }
  printf("Matrix B:\n");
  for(int i = 0; i < row; i++)
  {
    for(int j = 0; j < col; j++)
    {
        printf("%d ", MatrixB[i][j]);
    }
    printf("\n");
  }
  printf("================\n");
  printf("Matrix C:\n");
  for(int i = 0; i < row; i++)
  {
    for(int j = 0; j < col; j++)
    {
        MatrixC[i][j] = MatrixA[i][j] + MatrixB[i][j];
        printf("%d ", MatrixC[i][j]);
    }
    printf("\n");
  }
}

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
        // Matrix[i][j] = rand()%10;
        Matrix[i][j] = rand();
    }
  }
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

int main()
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
    fp = fopen ("test.txt","w");
    printf("N: %d T: %f\n",i,timeavg);
    fprintf(fp, "%d, %f\n",i,timeavg);
    fclose (fp);

    printf("N: %d T: %f\n",i,timeavg);
  }
  return 0;
}
