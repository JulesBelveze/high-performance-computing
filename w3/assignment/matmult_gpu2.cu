// GPU Sequential version v2

__global__
void gpu2(int m, int n, int k, double *a, double *b, double *c){
    int x, y;
    double sum = 0.0;

    x = blockIdx.x*blockDim.x + threadIdx.x; // col
    y = blockIdx.y*blockDim.y + threadIdx.y; // row

    for(i = 0; i < k; i++){
        sum += a[y*k+i]*b[i*n + x];
    }

    c[y*k + x] = sum;
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
    cudaMalloc((void **)&d_a, n*k*sizeof(double));
    cudaMalloc((void **)&d_b, k*m*sizeof(double));
    cudaMalloc((void **)&d_c, m*n*sizeof(double));

    // copying input to device
    cudaMemcpy(d_a, a, n*k*sizeof(double), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, k*m*sizeof(double), cudaMemcpyHostToDevice);

    gpu2<<<dimGrid,dimBlock>>>(m, n, k, d_a, d_b, d_c);
    cudaDeviceSynchronize();

    cudaMemcpy(c, d_c, m * n * sizeof(double), cudaMemcpyDeviceToHost);

    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
}
