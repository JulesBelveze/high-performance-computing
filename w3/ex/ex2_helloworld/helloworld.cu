#include <stdio.h>
#include <helper_cuda.h>

void timestamp()
{
    time_t ltime; /* calendar time */
    ltime=time(NULL); /* get current cal time */
    printf("%s",asctime( localtime(&ltime) ) );
}

__global__ void hello_thread()
{
  int g_tid = threadIdx.x + blockIdx.x * blockDim.x;
  int b_tid = threadIdx.x;
  int bid = blockIdx.x;
  // 258 without if statement
  // 194 with if statement
  // 64 lines missing
  if(g_tid == 100){
     int *a = (int*) 0x10000; *a = 0;
  }
  printf("Hello world! I’m thread %d out of %d in block %d. My global thread id is %d out of %d.\n",b_tid,blockDim.x,bid,g_tid,gridDim.x*blockDim.x);
}

#define total_threads 256
#define threads_per_block 64
int main() {
  printf("Hello World!\n");
  timestamp();
  // Launch kernel using 64 threads per block
  hello_thread<<<total_threads/threads_per_block, threads_per_block>>>();
  // cudaDeviceSynchronize();
  checkCudaErrors(cudaDeviceSynchronize());
}
