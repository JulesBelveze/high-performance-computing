#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void timestamp()
{
    time_t ltime; /* calendar time */
    ltime=time(NULL); /* get current cal time */
    printf("%s",asctime( localtime(&ltime) ) );
}

int main(int argc, char** argv)
{
  timestamp();
  char *runtime = argv[0]; // not used
  char *method = argv[1];
  int n = argv[2];
  int k = argv[3];
  int d = argv[4];

  printf("runtime:\t%s\n",runtime);
  printf("method:\t%s\n",method);
  printf("n: %d\n",n);
  printf("k: %d\n",k);
  printf("d: %d\n",d);

  return 0;
}
