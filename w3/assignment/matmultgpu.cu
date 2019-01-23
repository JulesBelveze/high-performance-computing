extern "C" {
#include <stdio.h>
}

#define nb_elt 10

__global__
void gpu1(int m, int n, int k, double *a, double *b, double *c){
    int i, j, p;

    for (i = 0; i < m*n; i++){
        c[i] = 0.0;
    }

    for(i = 0; i < m; i++){
        for(p = 0; p < k; p++){
            for(j = 0; j < n; j++){
                c[i*n+j] += a[i*k+p]*b[p*n+j];
            }
        }
    }
}


__global__
void gpu2(int m, int n, int k, double *a, double *b, double *c){
    int x, y, i;
    double sum = 0.0;

    x = blockIdx.x*blockDim.x + threadIdx.x; // col
    y = blockIdx.y*blockDim.y + threadIdx.y; // row

    for(i = 0; i < k; i++){
        sum += a[y*k+i]*b[i*n + x];
    }

    c[y*k + x] = sum;
}

__global__
void gpu3(int m, int n, int k, double *a, double *b, double *c){
    int x, y, i;
    double sum1 = 0.0, sum2 = 0.0;

    x = blockIdx.x*blockDim.x + threadIdx.x; // col
    y = blockIdx.y*blockDim.y + threadIdx.y; // row

    if( y == n-1){
        // if we are in the last row we only compute one element
        for(i = 0; i < k; i++){
            sum1 += a[y*k+i]*b[i*n + x];
        }
        c[y*k + x] = sum1;

    }else{
        // otherwise we can compute two elements
        for(i = 0; i < k; i++){
            sum1 += a[y*k+i]*b[i*n + x];
            sum2 += a[y*k+i+1]*b[i*n + x];
        }

        c[y*k + x] = sum1;
        c[y*k + x+1] = sum2;
    }
}


__global__
void gpu4(int m, int n, int k, double *a, double *b, double *c){
    int i,j,l,t;

    i = nb_elt*(blockIdx.y*blockDim.y+threadIdx.y);
    j = blockIdx.x*blockDim.x+threadIdx.x;

    if (i < m-nb_elt && j < n) {
        for (t = 0; t < nb_elt; t++) {
            for (l = 0; l < k; l++) {
                c[(i+t)*n+j] += a[(i+t)*k+l]*b[l*n+j];
            }
        }
    }
    else if (i < m && j < n) {
        for (t = 0; t < nb_elt; t++) {
            if (i+t < m) {
                for (l = 0; l < k; l++) {
                    c[(i+t)*n+j] += a[(i+t)*k+l]*b[l*n+j];
                }
            }
        }
    }
}


__global__
void gpu5(int m, int n, int k, double *a, double *b, double *c) {

	int i,j,r,s;

	double c_val = 0.0;

	i = blockIdx.y*blockDim.y + threadIdx.y; // row in C
	j = blockIdx.x*blockDim.x + threadIdx.x; // col in C

	for (r = 0; r < k/blockDim.x; r++) {

		__shared__ double a_blk[16][16];
		__shared__ double b_blk[16][16];

		a_blk[threadIdx.y][threadIdx.x] = a[i*k+r*blockDim.x+threadIdx.x];
		b_blk[threadIdx.y][threadIdx.x] = b[(r*blockDim.y+threadIdx.y)*n+j];

		__syncthreads(); // submatrices loaded before starting computation

		for (s = 0; s < blockDim.x; s++) {
			c_val += a_blk[threadIdx.y][s]*b_blk[s][threadIdx.x];
		}

		__syncthreads();
	}
	c[i*n+j] = c_val;
}
