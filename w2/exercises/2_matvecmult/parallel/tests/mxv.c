#include <stdio.h>


int
main(int m, int n, double *a, double *b, double *c)
{
    int i, j;
    double sum;

    #pragma omp parallel for default(none) \
        shared(m, n, a, b, c) private(i, j, sum)

    for (i=0; i<m; i++) {
        sum = 0.0;
        for (j=0; j<n; j++){
            sum += b[i*n+j] * c[j];
        }
        a[i] = sum;
    }
    return 0;
}
