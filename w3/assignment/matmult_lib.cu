extern "C" {
    #include <cblas.h> }

// CBLAS version
void matmult_lib(int m, int n, int k, double *a, double *b, double *c) {
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m, n, k, 1.0, \
                                        a, k, b, n, 0.0, c, n);
}
