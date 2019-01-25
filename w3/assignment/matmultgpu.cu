#define NB_ELT 11

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

    if (y < m && x < n) {
        for(i = 0; i < k; i++){
            sum += a[y*k+i]*b[i*n + x];
        }
        c[y*n + x] = sum;
    }
}

__global__
void gpu3(int m, int n, int k, double *a, double *b, double *c){
    int x, y, i;
	double sum=0.0, sum2=0.0;

	y = blockIdx.y*blockDim.y + threadIdx.y;
	x = 2*(blockIdx.x*blockDim.x + threadIdx.x);

	if ((y < m) && (x < n-1)) {
		for(i = 0; i < k; i++){
			sum += a[y*k+i]*b[i*n + x];
			sum2 += a[y*k+i]*b[i*n + x +1];
			}
		c[y*n+x] = sum;
		c[y*n+x+1] = sum2;
	}
	else if ((y < m) && (x == n-1)){
		for(i = 0; i < k; i++){
			sum += a[y*k+i]*b[i*n + x];
			}
		c[y*n+x] = sum;
	}
}


__global__
void gpu4(int m, int n, int k, double *a, double *b, double *c){
    int x,y,l,t;


    y = NB_ELT*(blockIdx.y*blockDim.y+threadIdx.y);
    x = blockIdx.x*blockDim.x+threadIdx.x;

    if (y < m-NB_ELT && x < n) {
        for (t = 0; t < NB_ELT; t++) {
            for (l = 0; l < k; l++) {
                c[(y+t)*n+x] += a[(y+t)*k+l]*b[l*n+x];
            }
        }
    }
    else if (y < m && x < n) {
        for (t = 0; t < NB_ELT; t++) {
            if (y+t < m) {
                for (l = 0; l < k; l++) {
                    c[(y+t)*n+x] += a[(y+t)*k+l]*b[l*n+x];
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
