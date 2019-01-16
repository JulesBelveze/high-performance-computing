void init_data (int N,double **u_new, double **u_old, double **f);

int check_results(char *comment, /* comment string 		 */
                  int m,         /* number of rows               */
		  int n,         /* number of columns            */
		  double **a      /* vector of length m           */
		 );

double ** malloc_2d(int m, 	/* number of rows               */
                    int n	/* number of columns            */
		   );

void free_2d(double **A);       /* free data allocated by malloc_2d */
