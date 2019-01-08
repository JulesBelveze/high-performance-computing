#include <stdio.h>
#include <stdlib.h>

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

int main(){
  const int n = 3;
  int mA[n][n], mB[n][n];

  generate_matrix(n,n,mA);
  generate_matrix(n,n,mB);

  print_matrix(n,n,mA);
  printf("------\n");
  print_matrix(n,n,mB);
  printf("------\n");

  return 0;
}
