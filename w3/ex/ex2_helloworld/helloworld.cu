#include <stdio.h>
#include <helper_cuda.h>



void timestamp()
{
    time_t ltime; /* calendar time */
    ltime=time(NULL); /* get current cal time */
    printf("%s",asctime( localtime(&ltime) ) );
}

__global__ void use_local_memory()
{
  int g_tid = threadIdx.x + blockIdx.x * blockDim.x;
  // printf("Global Thread ID: %d\n",g_tid);
  int b_tid = threadIdx.x;
  // printf("Block Thread ID: %d\n",b_tid);
  int bid = blockIdx.x;
  // printf("Block ID: %d\n",bid);
  printf("Hello world! I’m thread %d out of 64 in block %d. My global thread id is %d out of 256.\n",b_tid,bid,g_tid);
}

#define N 256
int main() {
  printf("Hello World!\n");
  timestamp();
  // Launch kernel using 30 threads per block
  use_local_memory<<<N/30, 30>>>();
  cudaDeviceSynchronize();
}
