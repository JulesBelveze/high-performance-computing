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
    printf("You have entered %d args\n",argc);
    for (int i = 0; i < argc; ++i){
      printf("%s\n",argv[i]);
    }
    return 0;
}
