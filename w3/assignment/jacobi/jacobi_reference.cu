#include <stdio.h>
#include <math.h>
#include "datatools.h"
#include <stdlib.h>
#include <omp.h>
#include <helper_cuda.h>

#define BLOCK_SIZE 16

void jacobi_cpu(int n, int num_iterations, double *f, double *u)
{

  double delta_square = 2.0 / (n + 1) * 2.0 / (n + 1);
  int k = 0, i, j;
  double *temp = NULL;
  double *u_old, *u_new;
  double ts, te;
  u_old = (double *)malloc((n + 2) * (n + 2) * sizeof(double));
  u_new = (double *)malloc((n + 2) * (n + 2) * sizeof(double));
  // Get starting time
  ts = omp_get_wtime();
#pragma omp parallel default(none) shared(n, u, u_old, num_iterations, f, delta_square, temp, k, u_new) private(j, i)
  {
#pragma omp for private(i, j)
    for (i = 0; i <= n + 1; i++)
    {
      for (j = 0; j <= n + 1; j++)
      {
        u_old[i * (n + 2) + j] = u[i * (n + 2) + j];
        u_new[i * (n + 2) + j] = u[i * (n + 2) + j];
      }
    }

    while (k < num_iterations)
    {
#pragma omp for private(i, j)
      for (i = 1; i <= n; i++)
      {
        for (j = 1; j <= n; j++)
        {
          u_new[i * (n + 2) + j] = 0.25 * (u_old[(i - 1) * (n + 2) + j] + u_old[(i + 1) * (n + 2) + j] + u_old[i * (n + 2) + (j - 1)] + u_old[i * (n + 2) + (j + 1)] + delta_square * f[i * (n + 2) + j]);
        }
      }

#pragma omp single
      {
        k += 1;
        temp = u_old;
        u_old = u_new;
        u_new = temp;
      }
    }
  }

  // Get ending time
  te = omp_get_wtime() - ts;
  // print results, e.g. timings, data, etc
  printf("%f\n", te);
}

__global__ void kernel1(int N, double *mat_old, double *mat_new, double *f, double delta_square)
{
  int i, j;

  for (i = 1; i < N - 1; i++)
  {
    for (j = 1; j < N - 1; j++)
    {
      mat_new[i * N + j] = 0.25 * (mat_old[i * N + (j - 1)] + mat_old[i * N + (j + 1)] + mat_old[(i + 1) * N + j] + mat_old[(i - 1) * N + j] + delta_square * f[i * N + j]);
    }
  }
}

void jacobi_gpu1(int N, int num_iterations, double *f, double *u)
{ // Variables declaration
  int k;
  double *h_U, *h_f, *d_U, *d_U_old, *d_U_new, *d_f, *temp_ptr;
  double ts, te;

  double delta_square = 2.0 / (N + 1) * 2.0 / (N + 1);

  // allocate memory for the necessary data fields
  cudaMalloc((void **)&d_U, N * N * sizeof(double));
  cudaMalloc((void **)&d_U_new, N * N * sizeof(double));
  cudaMalloc((void **)&d_f, N * N * sizeof(double));
  cudaMallocHost((void **)&h_U, N * N * sizeof(double));
  cudaMallocHost((void **)&h_f, N * N * sizeof(double));

  // copy data from host to device
  cudaMemcpy(d_U, h_U, N * N * sizeof(double), cudaMemcpyHostToDevice);
  cudaMemcpy(d_f, h_f, N * N * sizeof(double), cudaMemcpyHostToDevice);

  // call kernel iterator
  // Get starting time
  ts = omp_get_wtime();

  // Assign mat_old with the initial guess (k = 0 iteration)
  d_U_old = d_U;
  for (k = 0; k < num_iterations; k++)
  {
    kernel1<<<1, 1>>>(N, d_U_old, d_U_new, d_f, delta_square);
    checkCudaErrors(cudaDeviceSynchronize());

    // Swap the pointers on the CPU
    temp_ptr = d_U_old;
    d_U_old = d_U_new;
    d_U_new = temp_ptr;
  }

  // Get ending time
  te = omp_get_wtime() - ts;

  // Copy result back to host (notice that d_U_old will have the last good result!)
  cudaMemcpy(h_U, d_U_old, N * N * sizeof(double), cudaMemcpyDeviceToHost);

  // print results, e.g. timings, data, etc
  printf("%f\n", te);

  // Cleanup
  cudaFreeHost(h_U);
  cudaFreeHost(h_f);
  cudaFree(d_f);
  cudaFree(d_U);
  cudaFree(d_U_new);
}

__global__ void naive_kernel(int N, double *mat_old, double *mat_new, double *f, double delta_square)
{
  int i, j;

  i = blockIdx.y * blockDim.y + threadIdx.y;
  j = blockIdx.x * blockDim.x + threadIdx.x;

  if (i >= N || j >= N)
    return;

  // Check boundary values (should be copied in the new matrix as they are)
  if (i == 0 || i == N - 1 || j == 0 || j == N - 1)
    mat_new[i * N + j] = mat_old[i * N + j];
  else
  {
    mat_new[i * N + j] = 0.25 * (mat_old[i * N + (j - 1)] + mat_old[i * N + (j + 1)] + mat_old[(i + 1) * N + j] + mat_old[(i - 1) * N + j] + delta_square * f[i * N + j]);
  }
}

void jacobi_gpu2(int N, int num_iterations, double *d_f, double *d_U)
{
  int k;
  double *h_U, *h_f, *d_U_old, *d_U_new, *temp_ptr;
  double ts, te;
  double delta_square = 2.0 / (N + 1) * 2.0 / (N + 1);

  // allocate memory for the necessary data fields
  cudaMalloc((void **)&d_U, N * N * sizeof(double));
  cudaMalloc((void **)&d_U_new, N * N * sizeof(double));
  cudaMalloc((void **)&d_f, N * N * sizeof(double));
  cudaMallocHost((void **)&h_U, N * N * sizeof(double));
  cudaMallocHost((void **)&h_f, N * N * sizeof(double));

  // copy data from host to device
  cudaMemcpy(d_U, h_U, N * N * sizeof(double), cudaMemcpyHostToDevice);
  cudaMemcpy(d_f, h_f, N * N * sizeof(double), cudaMemcpyHostToDevice);

  // Define GPU thread blocks dimensions
  dim3 threads_per_block(BLOCK_SIZE, BLOCK_SIZE); // e.g. 16*16 = 256 threads in total
  dim3 num_blocks(ceil((double)N / threads_per_block.x), ceil((double)N / threads_per_block.y));

  // call kernel iterator
  // Get starting time
  ts = omp_get_wtime();

  // Assign mat_old with the initial guess (k = 0 iteration)
  d_U_old = d_U;
  for (k = 0; k < num_iterations; k++)
  {
    naive_kernel<<<num_blocks, threads_per_block>>>(N, d_U_old, d_U_new, d_f, delta_square);
    checkCudaErrors(cudaDeviceSynchronize());

    // Swap the pointers on the CPU
    temp_ptr = d_U_old;
    d_U_old = d_U_new;
    d_U_new = temp_ptr;
  }
  // Get ending time
  te = omp_get_wtime() - ts;

  // Copy result back to host (notice that d_U_old will have the last good result!)
  cudaMemcpy(h_U, d_U_old, N * N * sizeof(double), cudaMemcpyDeviceToHost);

  // print results, e.g. timings, data, etc
  printf("%f\n", te);

  // Cleanup
  cudaFreeHost(h_U);
  cudaFreeHost(h_f);
  cudaFree(d_f);
  cudaFree(d_U);
  cudaFree(d_U_new);
}

__global__ void kernel30(int n, double *mat_old, double *mat_new, double *f, double delta_square)
{
  int i, j;

  i = blockIdx.y * blockDim.y + threadIdx.y;
  j = blockIdx.x * blockDim.x + threadIdx.x;

  if (i < 1 || i >= n && j < 1 && j >= n)
    return;

  if (i > 0 && i < n / 2 && j > 0 && j <= n)
  {
    mat_new[i * (n + 2) + j] = 0.25 * (mat_old[(i - 1) * (n + 2) + j] + mat_old[(i + 1) * (n + 2) + j] + mat_old[i * (n + 2) + (j - 1)] + mat_old[i * (n + 2) + (j + 1)] + delta_square * f[i * (n + 2) + j]);
  }
  else if (i == n / 2 && j > 0 && j <= n)
  {
    mat_new[i * (n + 2) + j] = 0.25 * (mat_old[(i - 1) * (n + 2) + j] + mat_old[j] + mat_old[i * (n + 2) + (j - 1)] + mat_old[i * (n + 2) + (j + 1)] + delta_square * f[i * (n + 2) + j]);
  }
}

__global__ void kernel31(int n, double *mat_old, double *mat_new, double *f, double delta_square)
{
  int i, j;

  i = blockIdx.y * blockDim.y + threadIdx.y;
  j = blockIdx.x * blockDim.x + threadIdx.x;

  if (i < 1 || i >= n && j < 1 && j >= n)
    return;

  if (i > 0 && i < n / 2 && j > 0 && j <= n)
  {
    mat_new[i * (n + 2) + j] = 0.25 * (mat_old[(i - 1) * (n + 2) + j] + mat_old[(i + 1) * (n + 2) + j] + mat_old[i * (n + 2) + (j - 1)] + mat_old[i * (n + 2) + (j + 1)] + delta_square * f[i * (n + 2) + j]);
  }
  else if (i == n / 2 && j > 0 && j <= n)
  {
    mat_new[i * (n + 2) + j] = 0.25 * (mat_old[(i - 1) * (n + 2) + j] + mat_old[j] + mat_old[i * (n + 2) + (j - 1)] + mat_old[i * (n + 2) + (j + 1)] + delta_square * f[i * (n + 2) + j]);
  }
}

void jacobi_gpu3(int N, int num_iterations, double *h_f, double *h_U)
{
  // Variables declaration
  int k;
  double *d0_U, *d1_U, *d0_U_old, *d1_U_old, *d0_U_new, *d1_U_new, *d0_f, *d1_f, *temp_ptr;
  double delta, ts, te;

  // Allocate host memory
  cudaMallocHost((void **)&h_U, N * N * sizeof(double));
  cudaMallocHost((void **)&h_f, N * N * sizeof(double));

  double delta_square = 2.0 / (N + 1) * 2.0 / (N + 1);

  // Define GPU thread blocks dimensions
  dim3 threads_per_block(BLOCK_SIZE, BLOCK_SIZE); // e.g. 16*16 = 256 threads in total
  dim3 num_blocks(ceil((double)N / (threads_per_block.x * 2)), ceil((double)N / (threads_per_block.y * 2)));

  // Device 0
  cudaSetDevice(0);
  cudaDeviceEnablePeerAccess(1, 0);
  // allocate memory for the necessary data fields
  cudaMalloc((void **)&d0_U, N / 2 * N * sizeof(double));
  cudaMalloc((void **)&d0_U_new, N / 2 * N * sizeof(double));
  cudaMalloc((void **)&d0_f, N / 2 * N * sizeof(double));

  // copy data from host to device
  cudaMemcpy(d0_U, h_U, N / 2 * N * sizeof(double), cudaMemcpyHostToDevice);
  cudaMemcpy(d0_f, h_f, N / 2 * N * sizeof(double), cudaMemcpyHostToDevice);

  // Device 1
  cudaSetDevice(1);
  cudaDeviceEnablePeerAccess(0, 0);
  // allocate memory for the necessary data fields
  cudaMalloc((void **)&d1_U, N / 2 * N * sizeof(double));
  cudaMalloc((void **)&d1_U_new, N / 2 * N * sizeof(double));
  cudaMalloc((void **)&d1_f, N / 2 * N * sizeof(double));

  // copy data from host to device
  cudaMemcpy(d1_U, h_U + N / 2, N / 2 * N * sizeof(double), cudaMemcpyHostToDevice);
  cudaMemcpy(d1_f, h_f + N / 2, N / 2 * N * sizeof(double), cudaMemcpyHostToDevice);

  // k1 = (n + 1) / 16 + 1;
  // k2 = (n + 1) / 32 + 1;
  // dim3 dimBlock(16, 16, 1);
  // dim3 dimGrid(k1, k2, 1);

  // Get starting time
  ts = omp_get_wtime();

  // Assign mat_old with the initial guess (k = 0 iteration)
  d0_U_old = d0_U;
  d1_U_old = d1_U;
  for (k = 0; k < num_iterations; k++)
  {
    cudaSetDevice(0);
    kernel30<<<num_blocks, threads_per_block>>>(N, d0_U_old, d0_U_new, d0_f, delta_square);
    cudaSetDevice(1);
    kernel31<<<num_blocks, threads_per_block>>>(N, d1_U_old, d1_U_new, d1_f, delta_square);
    checkCudaErrors(cudaDeviceSynchronize());

    // Swap the pointers on the CPU
    temp_ptr = d0_U_old;
    d0_U_old = d0_U_new;
    d0_U_new = temp_ptr;

    temp_ptr = d1_U_old;
    d1_U_old = d1_U_new;
    d1_U_new = temp_ptr;
  }

  // Get ending time
  te = omp_get_wtime() - ts;

  // Copy result back to host (notice that d_U_old will have the last good result!)
  cudaMemcpy(h_U, d0_U_old, N / 2 * N * sizeof(double), cudaMemcpyDeviceToHost);
  cudaMemcpy(h_U + N / 2, d1_U_old, N / 2 * N * sizeof(double), cudaMemcpyDeviceToHost);

  // print results, e.g. timings, data, etc
  printf("%f\n", te);

  // Cleanup
  cudaFreeHost(h_U);
  cudaFreeHost(h_f);
  cudaSetDevice(0);
  cudaFree(d0_f);
  cudaFree(d0_U);
  cudaFree(d0_U_new);
  cudaSetDevice(1);
  cudaFree(d1_f);
  cudaFree(d1_U);
  cudaFree(d1_U_new);
}
