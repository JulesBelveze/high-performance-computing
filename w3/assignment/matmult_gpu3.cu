// CPU version 3

__global__
void gpu3(int m, int n, int k, double *a, double *b, double *c){
    int x, y;
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

void matmult_gpu3(int m, int n, int k, double *a, double *b, double *c){
    double *d_a, *d_b, *d_c;
    int k1, k2;

    // preparing GPU grid and block
    k1 = (n-1)/16+1;
    k2 = (m-1)/16+1;
    dim3 dimBlock(16,16,1);
	dim3 dimGrid((k1-1)/2+1,k2,1);

    // allocate space for device copies
    cudaMalloc((void **)&d_a, n*k*sizeof(double));
    cudaMalloc((void **)&d_b, k*m*sizeof(double));
    cudaMalloc((void **)&d_c, m*n*sizeof(double));

    // copying input to device
    cudaMemcpy(d_a, a, n*k*sizeof(double), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, k*m*sizeof(double), cudaMemcpyHostToDevice);

    gpu3<<<dimGrid,dimBlock>>>(m, n, k, d_a, d_b, d_c);
    cudaDeviceSynchronize();

    cudaMemcpy(c, d_c, m * n * sizeof(double), cudaMemcpyDeviceToHost);

    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
}
