extern "C" {
#include <cblas.h>
#include <math.h>
#include <stdio.h>
#include <omp.h>
}
#include "matmultgpu.h"
#include <helper_cuda.h>
#include "cublas_v2.h"

extern "C" {
#define NB_ELT 11

// cblas dgemm
void matmult_lib(int m, int n, int k, double *A, double *B, double *C)
{
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m, n, k, 1, A, k, B, n, 0, C, n);
}

void matmult_gpu1(int m, int n, int k,  double *a, double *b, double *c){
    double *d_a, *d_b, *d_c;

    // allocate space for device copies
    cudaMalloc((void **)&d_a, m*k*sizeof(double));
    cudaMalloc((void **)&d_b, k*n*sizeof(double));
    cudaMalloc((void **)&d_c, m*n*sizeof(double));

    // copying input to device
    cudaMemcpy(d_a, a, n*k*sizeof(double), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, k*m*sizeof(double), cudaMemcpyHostToDevice);

    double time = omp_get_wtime();
    gpu1<<<1,1>>>(m, n, k, d_a, d_b, d_c);

    cudaDeviceSynchronize();
    double elapsed = omp_get_wtime() - time;

    printf("%f \n", elapsed);

    // copying output to host
    cudaMemcpy(c, d_c, m*n*sizeof(double), cudaMemcpyDeviceToHost);

    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
}


void matmult_gpu2(int m, int n, int k, double *a, double *b, double *c){
    double *d_a, *d_b, *d_c;
    int k1, k2;

    // preparing GPU grid and block
    k1 = (n-1)/16+1;
    k2 = (m-1)/16+1;
    dim3 dimBlock(16,16,1);
    dim3 dimGrid(k1,k2,1);

    // allocate space for device copies
    cudaMalloc((void **)&d_a, m*k*sizeof(double));
    cudaMalloc((void **)&d_b, k*n*sizeof(double));
    cudaMalloc((void **)&d_c, m*n*sizeof(double));

    // copying input to device
    cudaMemcpy(d_a, a, m*k*sizeof(double), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, k*n*sizeof(double), cudaMemcpyHostToDevice);

    gpu2<<<dimGrid,dimBlock>>>(m, n, k, d_a, d_b, d_c);
    cudaDeviceSynchronize();

    cudaMemcpy(c, d_c, m * n * sizeof(double), cudaMemcpyDeviceToHost);

    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
}


void matmult_gpu3(int m, int n, int k, double *a, double *b, double *c){
    double *d_a, *d_b, *d_c;
    int k1, k2;

    // preparing GPU grid and block
    k1 = (n-1)/16+1;
    k2 = (m-1)/16+1;
    dim3 dimBlock(16,16,1);
	dim3 dimGrid((k1-1)/2+1,k2,1);

    // allocate space for device copies
    cudaMalloc((void **)&d_a, m*k*sizeof(double));
    cudaMalloc((void **)&d_b, k*n*sizeof(double));
    cudaMalloc((void **)&d_c, m*n*sizeof(double));

    // copying input to device
    cudaMemcpy(d_a, a, m*k*sizeof(double), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, k*n*sizeof(double), cudaMemcpyHostToDevice);

    gpu3<<<dimGrid,dimBlock>>>(m, n, k, d_a, d_b, d_c);
    cudaDeviceSynchronize();

    cudaMemcpy(c, d_c, m * n * sizeof(double), cudaMemcpyDeviceToHost);

    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
}


void matmult_gpu4(int m, int n, int k, double *a, double *b, double *c){
    double *d_a, *d_b, *d_c;
    int k1, k2;

    // preparing GPU grid and block
    k1 = (n-1)/16+1;
    k2 = (m-1)/16+1;
    dim3 dimBlock(16,16,1);
	dim3 dimGrid(k1,(k2-1)/NB_ELT+1,1);

    // allocate space for device copies
    cudaMalloc((void **)&d_a, m*k*sizeof(double));
    cudaMalloc((void **)&d_b, k*n*sizeof(double));
    cudaMalloc((void **)&d_c, m*n*sizeof(double));

    // copying input to device
    cudaMemcpy(d_a, a, m*k*sizeof(double), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, k*n*sizeof(double), cudaMemcpyHostToDevice);

    gpu4<<<dimGrid,dimBlock>>>(m, n, k, d_a, d_b, d_c);
    cudaDeviceSynchronize();

    cudaMemcpy(c, d_c, m * n * sizeof(double), cudaMemcpyDeviceToHost);

    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
}


void
matmult_gpu5(int m, int n, int k, double *a, double *b, double *c) {

    double *d_a, *d_b, *d_c;
    int k1, k2;

    cudaMalloc((void **) &d_a, m * k * sizeof(double));
    cudaMalloc((void **) &d_b, k * n * sizeof(double));
    cudaMalloc((void **) &d_c, m * n * sizeof(double));

    cudaMemcpy(d_a, a, m * k * sizeof(double), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, k * n * sizeof(double), cudaMemcpyHostToDevice);

    k1 = (n-1)/16+1;
    k2 = (m-1)/16+1;
    dim3 dimBlock(16,16,1);
    dim3 dimGrid(k1,k2,1);

    gpu5<<<dimGrid,dimBlock>>>(m, n, k, d_a, d_b, d_c);
    cudaDeviceSynchronize();

    cudaMemcpy(c, d_c, m * n * sizeof(double), cudaMemcpyDeviceToHost);

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

}

void
matmult_gpulib(int m, int n, int k, double *a, double *b, double *c) {
    const double alpha = 1.0, beta = 0.0;
    double *d_a, *d_b, *d_c;

    cudaMalloc((void **)&d_a, m * k * sizeof(double));
    cudaMalloc((void **)&d_b, k * n * sizeof(double));
    cudaMalloc((void **)&d_c, m * n * sizeof(double));

    if (d_a == NULL || d_b == NULL || d_c == NULL)
    {
        fprintf(stderr, "memory allocation failed!\n");
        return;
    }

    cudaMemcpy(d_a, a, m * k * sizeof(double), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, k * n * sizeof(double), cudaMemcpyHostToDevice);

    cublasHandle_t handle;
    if(cublasCreate(&handle)!=CUBLAS_STATUS_SUCCESS)
    {
        printf("Error initializing CUDA runtime.\n");
        return;
    }

    cublasDgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N, n, m, k, &alpha, d_b, n, d_a, k, &beta, d_c, n);

    cublasDestroy(handle);

    checkCudaErrors(cudaDeviceSynchronize());

    cudaMemcpy(c, d_c, m * n * sizeof(double), cudaMemcpyDeviceToHost);

    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
}
}
