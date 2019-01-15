#include <stdio.h>
#include <stdlib.h>
#include <time.h>

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

void timestamp()
{
    time_t ltime; /* calendar time */
    ltime=time(NULL); /* get current cal time */
    printf("%s",asctime( localtime(&ltime) ) );
}

int main()
{
  timestamp();
  int row = 3;
  int col = 6;
  int mA[row][col];
  int vB[col];
  int vC[row];
  printf("generating vector:\n");
  generate_vector(col,vB);
  print_vector(col,vB);
  printf("generating matrix:\n");
  generate_matrix(row,col,mA);
  print_matrix(row,col,mA);

  printf("multiplying:\n");
  for(int i = 0; i < col; i++)
  {
    vC[i] = 0;
    for(int j = 0; j < row; j++)
    {
      // printf("----- %d * %d = %d\n",mA[i][j],vB[j],mA[i][j]*vB[j]);
      vC[i] += mA[i][j]*vB[j];
    }
    // printf("----- %d\n",vC[i]);
  }
  print_vector(row,vC);

  return 0;
}
