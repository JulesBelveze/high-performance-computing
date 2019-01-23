#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <cublas_v2.h>

extern "C" {
#include <cblas.h>

// CBLAS version
void matmult_lib(int m, int n, int k, double *a, double *b, double *c) {
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m, n, k, 1.0, \
                                        a, k, b, n, 0.0, c, n);
}

void
matmult_gpulib(int m, int n, int k, double *a, double *b, double *c) {

    const double alf = 1.0;
    const double bet = 0.0;

    const double *alpha = &alf;
    const double *beta = &bet;

    cublasHandle_t handle;
    //cublasOperation_t transa = "n";
    //cublasOperation_t transb = "n";
    cublasCreate(&handle);
    cublasDgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N, m, n, k, alpha, b, n, a, k, beta, c, n);
    cublasDestroy(handle);
}

}
