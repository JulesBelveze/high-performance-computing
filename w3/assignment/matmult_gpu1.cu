// GPU Sequential version v1

__global__
void gpu1(int m, int n, int k, double *a, double *b, double *c){
    int i, j, p;

    for(i = 0; i < m*n; i++){
        c[i] = 0.0;
    }

    for(i = 0; i < m; i++){
        for(p = 0; p < k; p++){
            for(j = 0; j < m; j++){
                c[i*n+j] += a[i*k+p]*b[p*n+j];
            }
        }
    }
}


void matmult_gpu1(int m, int n, int k,  double *a, double *b, double *c){
    double *d_a, *d_b, *d_c;

    // allocate space for device copies
    cudaMalloc((void **)&d_a, n*k*sizeof(double));
    cudaMalloc((void **)&d_b, k*m*sizeof(double));
    cudaMalloc((void **)&d_c, m*n*sizeof(double));

    // copying input to device
    cudaMemcpy(d_a, a, n*k*sizeof(double), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, k*m*sizeof(double), cudaMemcpyHostToDevice);

    gpu1<<<1,1>>>(m, n, k, d_a, d_b, d_c);

    cudaDeviceSynchronize();

    // copying output to host
    cudaMemcpy(c, d_c, n*sizeof(double), cudaMemcpyDeviceToHost);

    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
}
