// CPU version 4

// nb of elements to compute per thread
#define nb_elt 10

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

void matmult_gpu4(int m, int n, int k, double *a, double *b, double *c){
    double *d_a, *d_b, *d_c;
    int k1, k2;

    // preparing GPU grid and block
    k1 = (n-1)/16+1;
    k2 = (m-1)/16+1;
    dim3 dimBlock(16,16,1);
	dim3 dimGrid(k1,(k2-1)/nb_elts+1,1);

    // allocate space for device copies
    cudaMalloc((void **)&d_a, n*k*sizeof(double));
    cudaMalloc((void **)&d_b, k*m*sizeof(double));
    cudaMalloc((void **)&d_c, m*n*sizeof(double));

    // copying input to device
    cudaMemcpy(d_a, a, n*k*sizeof(double), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, k*m*sizeof(double), cudaMemcpyHostToDevice);

    gpu4<<<dimGrid,dimBlock>>>(m, n, k, d_a, d_b, d_c);
    cudaDeviceSynchronize();

    cudaMemcpy(c, d_c, m * n * sizeof(double), cudaMemcpyDeviceToHost);

    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
}
