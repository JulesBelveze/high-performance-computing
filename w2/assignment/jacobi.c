#include <stdio.h>
#include <math.h>

void
jacobi(int N, int num_iterations, double **f, double **u_new, double **u_old, double threshold){
	
	int i, j;
	int k =0;
	double dist = 100000000000.0;
	double norm;
	
	//grid spacing: 2/(N+1) (x goes from -1 to 1)
	double delta = 2/(N+1);
	while(dist > threshold && k< num_iterations){
		dist = 0.0;
		norm = 0.0;
		for(i=1; i<=N; i++){
			for(j=1;j<=N;j++){
				u_new[i][j]=0.25*(u_old[i-1][j]+u_old[i+1][j]+u_old[i][j-1]+u_old[i][j+1]+delta*delta*f[i][j]);
				dist += (u_new[i][j]-u_old[i][j])*(u_new[i][j]-u_old[i][j]);
				norm += u_new[i][j]*u_new[i][j];
			}
		}			
		dist = dist/norm;
		//update function
		double **temperature = u_new;
		u_new = u_old;
		u_old = temperature;
		k +=1;
	}
	printf("Iterations: %d\n distance: %.8f\n",k,dist);
}
		


