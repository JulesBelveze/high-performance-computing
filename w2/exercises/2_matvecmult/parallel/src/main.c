#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h> // Open MP

void generate_matrix(int row, int col, int Matrix[row][col])
{
  int i,j;
  for(i = 0; i < row; i++)
  {
    for(j = 0; j < col; j++)
    {
        Matrix[i][j] = rand()%10;
        //Matrix[i][j] = rand();
    }
  }
}

void generate_vector(int col, int outvector[col])
{
  int i;
  for(i = 0; i < col; i++)
  {
    outvector[i] = rand() % 10;
    // outvector[i] = rand();
  }
}

void print_vector(int col, int invector[col])
{
  int j;
  for(j = 0; j < col; j++)
  {
      printf("%d ", invector[j]);
  }
  printf("\n");
}

void print_matrix(int row, int col, int Matrix[row][col])
{
  int i,j;
  for(i = 0; i < row; i++)
  {
    for(j = 0; j < col; j++)
    {
        printf("%d ", Matrix[i][j]);
    }
    printf("\n");
  }
}

void timestamp()
{
    time_t ltime; /* calendar time */
    ltime=time(NULL); /* get current cal time */
    printf("%s",asctime( localtime(&ltime) ) );
}

int main()
{
  timestamp();
  int row = 300;
  int col = 6000;
  int mA[row][col];
  int vB[col];
  int vC[row];
  // printf("generating vector:\n");
  generate_vector(col,vB);
  // print_vector(col,vB);
  // printf("generating matrix:\n");
  generate_matrix(row,col,mA);
  // print_matrix(row,col,mA);

  // printf("multiplying:\n");
  int i, j;

  #pragma omp parallel default(none) \
              shared(row,col,mA,vB,vC) private(i,j) //reduction(+:vC)

  #pragma omp master
  printf("threads:%d\n",omp_get_num_threads());

  #pragma omp end master

  #pragma omp for
  for(i = 0; i < col; i++)
  {
    vC[i] = 0;
    for(j = 0; j < row; j++)
    {
      // printf("----- %d * %d = %d\n",mA[i][j],vB[j],mA[i][j]*vB[j]);
      vC[i] += mA[i][j]*vB[j];
    }
    // printf("----- %d\n",vC[i]);
  }
  #pragma omp end parallel
  // print_vector(row,vC);


  return 0;
}
