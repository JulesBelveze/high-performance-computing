void
gauss(int N, int num_iterations, double **f, double **u_new, double threshold){
	
	int i, j;
	int k =0;
	double dist = 100000000000.0;
	double norm;
	double u_old;
	threshold *= (N+1)*(N+1);
	//grid spacing: 2/(N+1) (x goes from -1 to 1)
	double delta = 2/(N+1);
	while(dist > threshold && k< num_iterations){
		dist = 0.0;
		norm = 0.0;
		for(i=1; i<=N; i++){
			for(j=1;j<=N;j++){
				u_new[i][j] = 0.25*(u_new[i-1][j]+u_new[i+1][j]+u_new[i][j-1]+u_new[i][j+1]+delta*delta*f[i][j]);
				dist += (u_new[i][j]-u_old)*(u_new[i][j]-u_old);
				
			}
		}			
		k +=1;
	}
	printf("Iterations: %d\n distance: %f\n",k,dist);
}
		


