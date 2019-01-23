#include <stdio.h>
#include <math.h>
#include "datatools.h"
#include <stdlib.h>
#include <omp.h>

void jacobi_cpu(int n, int num_iterations, double *f, double *u)
{

  double delta_square = 2.0 / (n + 1) * 2.0 / (n + 1);
  int k = 0, i, j;
  double *temp = NULL;
  double *u_old, *u_new;

  u_old = (double *)malloc((n + 2) * (n + 2) * sizeof(double));
  u_new = (double *)malloc((n + 2) * (n + 2) * sizeof(double));

#pragma omp parallel default(none) shared(n, u, u_old, num_iterations, f, delta_square, temp, k, u_new) private(j, i)
  {
#pragma omp for private(i, j) schedule(dynamic)
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

#pragma omp for private(i, j) schedule(dynamic)
	  for (i = 1; i <= n; i++)
	  {
		for (j = 1; j <= n; j++)
		{
		  u_new[i * (n + 2) + j] = 0.25 * (u_old[(i - 1) * (n + 2) + j] + u_old[(i + 1) * (n + 2) + j] + u_old[i * (n + 2) + (j - 1)] + u_old[i * (n + 2) + (j + 1)] + delta_square * f[i * (n + 2) + j]);
		}
	  }

	  k += 1;
#pragma omp single
	  {

		temp = u_old;
		u_old = u_new;
		u_new = temp;
	  }
	}
  }
}

__global__ void kernel1(int n, double *f, double *u)
{
  int i, j;
  double delta_square = 2.0 / (n + 1) * 2.0 / (n + 1);
  double *u_old, *u_new;
  u_old = (double *)malloc((n + 2) * (n + 2) * sizeof(double));
  u_new = (double *)malloc((n + 2) * (n + 2) * sizeof(double));

  for (i = 0; i <= n + 1; i++)
  {
	for (j = 0; j <= n + 1; j++)
	{
	  u_old[i * (n + 2) + j] = u[i * (n + 2) + j];
	  u_new[i * (n + 2) + j] = u[i * (n + 2) + j];
	}
  }

  for (i = 1; i <= n; i++)
  {
	for (j = 1; j <= n; j++)
	{
	  u_new[i * (n + 2) + j] = 0.25 * (u_old[(i - 1) * (n + 2) + j] + u_old[(i + 1) * (n + 2) + j] + u_old[i * (n + 2) + (j - 1)] + u_old[i * (n + 2) + (j + 1)] + delta_square * f[i * (n + 2) + j]);
	}
  }
}

void jacobi_gpu1(int n, int num_iterations, double *f, double *u)
{
  int k = 0;
  double *u_gpu, *u_old_gpu, *u_new_gpu, *f_gpu;
  double *u_old, *u_new;
  u_old = (double *)malloc((n + 2) * (n + 2) * sizeof(double));
  u_new = (double *)malloc((n + 2) * (n + 2) * sizeof(double));
  double *temp = NULL;

  cudaMalloc((void **)&u_gpu, (n + 2) * (n + 2) * sizeof(double));
  cudaMalloc((void **)&u_old_gpu, (n + 2) * (n + 2) * sizeof(double));
  cudaMalloc((void **)&u_new_gpu, (n + 2) * (n + 2) * sizeof(double));
  cudaMalloc((void **)&f_gpu, (n + 2) * (n + 2) * sizeof(double));
  //get time
  cudaMemcpy(u_gpu, u, (n + 2) * (n + 2) * sizeof(double), cudaMemcpyHostToDevice);
  cudaMemcpy(u_old_gpu, u_old, (n + 2) * (n + 2) * sizeof(double), cudaMemcpyHostToDevice);
  cudaMemcpy(u_new_gpu, u_new, (n + 2) * (n + 2) * sizeof(double), cudaMemcpyHostToDevice);
  cudaMemcpy(f_gpu, f, (n + 2) * (n + 2) * sizeof(double), cudaMemcpyHostToDevice);
  //get time
  while (k < num_iterations)
  {
	kernel1 <<<1, 1>>> (n, f_gpu, u_gpu);
	cudaDeviceSynchronize();
	temp = u_old_gpu;
	u_old_gpu = u_new_gpu;
	u_new_gpu = temp;
	k += 1;
	//get time
  }
  cudaMemcpy(u, u_gpu, (n + 2) * (n + 2) * sizeof(double), cudaMemcpyDeviceToHost);
  //get time
  cudaFree(u_gpu);
  cudaFree(u_old_gpu);
  cudaFree(u_new_gpu);
  cudaFree(f_gpu);
}

__global__ void naive_kernel(int n, double *f, double *u)
{
  int i, j;
  double delta_square = 2.0 / (n + 1) * 2.0 / (n + 1);
  double *u_old, *u_new;
  u_old = (double *)malloc((n + 2) * (n + 2) * sizeof(double));
  u_new = (double *)malloc((n + 2) * (n + 2) * sizeof(double));

  i = blockIdx.y * blockDim.y + threadIdx.y;
  j = blockIdx.x * blockDim.x + threadIdx.x;
  if (i > 0 && i <= n && j > 0 && j <= n)
  {
	u_old[i * (n + 2) + j] = u[i * (n + 2) + j];
	u_new[i * (n + 2) + j] = u[i * (n + 2) + j];
  }
  if (i > 0 && i <= n && j > 0 && j <= n)
  {
	u_new[i * (n + 2) + j] = 0.25 * (u_old[(i - 1) * (n + 2) + j] + u_old[(i + 1) * (n + 2) + j] + u_old[i * (n + 2) + (j - 1)] + u_old[i * (n + 2) + (j + 1)] + delta_square * f[i * (n + 2) + j]);
  }
}

void jacobi_gpu2(int n, int num_iterations, double *f, double *u)
{
  int k = 0;
  int k1, k2;
  double *u_gpu, *u_old_gpu, *u_new_gpu, *f_gpu;
  double *u_old, *u_new;
  u_old = (double *)malloc((n + 2) * (n + 2) * sizeof(double));
  u_new = (double *)malloc((n + 2) * (n + 2) * sizeof(double));
  double *temp = NULL;

  cudaMalloc((void **)&u_gpu, (n + 2) * (n + 2) * sizeof(double));
  cudaMalloc((void **)&u_old_gpu, (n + 2) * (n + 2) * sizeof(double));
  cudaMalloc((void **)&u_new_gpu, (n + 2) * (n + 2) * sizeof(double));
  cudaMalloc((void **)&f_gpu, (n + 2) * (n + 2) * sizeof(double));

  cudaMemcpy(u_gpu, u, (n + 2) * (n + 2) * sizeof(double), cudaMemcpyHostToDevice);
  cudaMemcpy(u_old_gpu, u_old, (n + 2) * (n + 2) * sizeof(double), cudaMemcpyHostToDevice);
  cudaMemcpy(u_new_gpu, u_new, (n + 2) * (n + 2) * sizeof(double), cudaMemcpyHostToDevice);
  cudaMemcpy(f_gpu, f, (n + 2) * (n + 2) * sizeof(double), cudaMemcpyHostToDevice);

  k1 = (n + 1) / 16 + 1;
  k2 = (n + 1) / 16 + 1;
  dim3 dimBlock(16, 16, 1);
  dim3 dimGrid(k1, k2, 1);

  while (k < num_iterations)
  {
	naive_kernel<<<dimGrid, dimBlock>>>(n, f_gpu, u_gpu);
	cudaDeviceSynchronize();
	temp = u_old_gpu;
	u_old_gpu = u_new_gpu;
	u_new_gpu = temp;
	k += 1;
  }
  cudaMemcpy(u, u_gpu, (n + 2) * (n + 2) * sizeof(double), cudaMemcpyDeviceToHost);
  //get time
  cudaFree(u_gpu);
  cudaFree(u_old_gpu);
  cudaFree(u_new_gpu);
  cudaFree(f_gpu);
}

__global__ void kernel30(int n, double *f, double *u, double *u_old_v2)
{
  int i, j;
  double delta_square = 2.0 / (n + 1) * 2.0 / (n + 1);
  double *u_old, *u_new;
  u_old = (double *)malloc((n + 2) * (n + 2) * sizeof(double));
  u_new = (double *)malloc((n + 2) * (n + 2) * sizeof(double));

  i = blockIdx.y * blockDim.y + threadIdx.y;
  j = blockIdx.x * blockDim.x + threadIdx.x;
  if (i > 0 && i <= n && j > 0 && j <= n)
  {
	u_old[i * (n + 2) + j] = u[i * (n + 2) + j];
	u_new[i * (n + 2) + j] = u[i * (n + 2) + j];
  }
  if (i > 0 && i < n / 2 && j > 0 && j <= n)
  {
	u_new[i * (n + 2) + j] = 0.25 * (u_old[(i - 1) * (n + 2) + j] + u_old[(i + 1) * (n + 2) + j] + u_old[i * (n + 2) + (j - 1)] + u_old[i * (n + 2) + (j + 1)] + delta_square * f[i * (n + 2) + j]);
  }
  else if (i == n / 2 && j > 0 && j <= n)
  {
	u_new[i * (n + 2) + j] = 0.25 * (u_old[(i - 1) * (n + 2) + j] + u_old_v2[j] + u_old[i * (n + 2) + (j - 1)] + u_old[i * (n + 2) + (j + 1)] + delta_square * f[i * (n + 2) + j]);
  }
}

__global__ void kernel31(int n, double *f, double *u, double *u_old_v2)
{
  int i, j;
  double delta_square = 2.0 / (n + 1) * 2.0 / (n + 1);
  double *u_old, *u_new;
  u_old = (double *)malloc((n + 2) * (n + 2) * sizeof(double));
  u_new = (double *)malloc((n + 2) * (n + 2) * sizeof(double));

  i = blockIdx.y * blockDim.y + threadIdx.y;
  j = blockIdx.x * blockDim.x + threadIdx.x;
  if (i > 0 && i <= n && j > 0 && j <= n)
  {
	u_old[i * (n + 2) + j] = u[i * (n + 2) + j];
	u_new[i * (n + 2) + j] = u[i * (n + 2) + j];
  }
  if (i > 0 && i < n / 2 && j > 0 && j <= n)
  {
	u_new[i * (n + 2) + j] = 0.25 * (u_old[(i - 1) * (n + 2) + j] + u_old[(i + 1) * (n + 2) + j] + u_old[i * (n + 2) + (j - 1)] + u_old[i * (n + 2) + (j + 1)] + delta_square * f[i * (n + 2) + j]);
  }
  else if (i == 0 && j > 0 && j <= n)
  {
	u_new[i * (n + 2) + j] = 0.25 * (u_old_v2[n / 2 * (n + 2) + j] + u_old[(i + 1) * (n + 2) + j] + u_old[i * (n + 2) + (j - 1)] + u_old[i * (n + 2) + (j + 1)] + delta_square * f[i * (n + 2) + j]);
  }
}

void jacobi_gpu3(int n, int num_iterations, double *f, double *u)
{
  int k = 0;
  int k1, k2;
  double *u_gpu0, *u_old_gpu0, *u_new_gpu0, *f_gpu0, *u_gpu1, *u_old_gpu1, *u_new_gpu1, *f_gpu1;
  double *u_old, *u_new;
  u_old = (double *)malloc((n + 2) * (n + 2) * sizeof(double));
  u_new = (double *)malloc((n + 2) * (n + 2) * sizeof(double));
  double *temp0 = NULL;
  double *temp1 = NULL;
  cudaSetDevice(0);
  cudaMalloc((void **)&u_gpu0, (n + 2) * (n + 2) * sizeof(double) / 2);
  cudaMalloc((void **)&u_old_gpu0, (n + 2) * (n + 2) * sizeof(double) / 2);
  cudaMalloc((void **)&f_gpu0, (n + 2) * (n + 2) * sizeof(double) / 2);
  cudaMalloc((void **)&u_new_gpu0, (n + 2) * (n + 2) * sizeof(double) / 2);

  cudaSetDevice(1);
  cudaMalloc((void **)&u_gpu1, (n + 2) * (n + 2) * sizeof(double) / 2);
  cudaMalloc((void **)&u_old_gpu1, (n + 2) * (n + 2) * sizeof(double) / 2);
  cudaMalloc((void **)&f_gpu1, (n + 2) * (n + 2) * sizeof(double) / 2);
  cudaMalloc((void **)&u_new_gpu1, (n + 2) * (n + 2) * sizeof(double) / 2);

  cudaSetDevice(0);
  cudaMemcpy(u_gpu0, u, (n + 2) * (n + 2) * sizeof(double) / 2, cudaMemcpyHostToDevice);
  cudaMemcpy(u_old_gpu0, u_old, (n + 2) * (n + 2) * sizeof(double) / 2, cudaMemcpyHostToDevice);
  cudaMemcpy(u_new_gpu0, u_new, (n + 2) * (n + 2) * sizeof(double) / 2, cudaMemcpyHostToDevice);
  cudaMemcpy(f_gpu0, f, (n + 2) * (n + 2) * sizeof(double) / 2, cudaMemcpyHostToDevice);
  cudaDeviceEnablePeerAccess(1, 0);

  cudaSetDevice(1);
  cudaMemcpy(u_gpu1, u + (n + 2) * (n + 2) / 2, (n + 2) * (n + 2) * sizeof(double) / 2, cudaMemcpyHostToDevice);
  cudaMemcpy(u_old_gpu1, u_old + (n + 2) * (n + 2) / 2, (n + 2) * (n + 2) * sizeof(double) / 2, cudaMemcpyHostToDevice);
  cudaMemcpy(f_gpu1, f + (n + 2) * (n + 2) / 2, (n + 2) * (n + 2) * sizeof(double) / 2, cudaMemcpyHostToDevice);
  cudaMemcpy(u_new_gpu1, u_new + (n + 2) * (n + 2) / 2, (n + 2) * (n + 2) * sizeof(double) / 2, cudaMemcpyHostToDevice);
  cudaDeviceEnablePeerAccess(0, 0);

  k1 = (n + 1) / 16 + 1;
  k2 = (n + 1) / 32 + 1;
  dim3 dimBlock(16, 16, 1);
  dim3 dimGrid(k1, k2, 1);

  while (k < num_iterations)
  {
	cudaSetDevice(0);
	kernel30<<<dimGrid, dimBlock>>>(n, f_gpu0, u_gpu0, u_old_gpu1);

	cudaSetDevice(1);
	kernel31<<<dimGrid, dimBlock>>>(n, f_gpu1, u_gpu1, u_old_gpu0);
	cudaDeviceSynchronize();

	cudaSetDevice(0);
	cudaDeviceSynchronize();

	temp0 = u_old_gpu0;
	u_old_gpu0 = u_new_gpu0;
	u_new_gpu0 = temp0;

	temp1 = u_old_gpu1;
	u_old_gpu1 = u_new_gpu1;
	u_new_gpu1 = temp1;
	k += 1;
  }
  cudaSetDevice(0);
  cudaMemcpy(u, u_gpu0, (n + 2) * (n + 2) * sizeof(double) / 2, cudaMemcpyDeviceToHost);
  cudaFree(u_gpu0);
  cudaFree(u_old_gpu0);
  cudaFree(f_gpu0);
  cudaFree(u_new_gpu0);

  cudaSetDevice(1);
  cudaMemcpy(u + (n + 2) * (n + 2) / 2, u_gpu1, (n + 2) * (n + 2) * sizeof(double) / 2, cudaMemcpyDeviceToHost);
  //t6 = omp_get_wtime();
  cudaFree(u_gpu1);
  cudaFree(u_old_gpu1);
  cudaFree(f_gpu1);
  cudaFree(u_new_gpu1);
}
