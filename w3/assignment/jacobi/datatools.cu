/* datatools.c - support functions for the matrix examples
 *
 * Author:  Bernd Dammann, DTU Compute
 * Version: $Revision: 1.2 $ $Date: 2015/11/10 11:03:12 $
 */
#include <stdlib.h>
#include <stdio.h>
#include <float.h>
#include <math.h>

#include "datatools.h"

void init_data(int N, double *u, double *f)
{
    int i, j;
    double x, y;
    double h = 2.0 / (N + 1);

    #pragma omp parallel for private(i,j)
    for (i = 0; i < N + 2; i++)
    {
        for (j = 0; j < N + 2; j++)
        {
            if (i == 0 || j == 0 || j == N + 1)
            { // setting 20.0-borders
                u[i * (N + 2) + j] = 20.0;
            }
            else
            { // setting inner point and 0.0-border
                u[i * (N + 2) + j] = 0.0;
            }

            x = -1 + j * h;
            y = 1 - i * h;
            // 0≤x≤1/3, −2/3≤y≤−1/3
            if (x >= 0 && x <= 1.0 / 3 && y >= -2.0 / 3 && y <= -1.0 / 3)
            {
                f[i * (N + 2) + j] = 200.0;
            }
            else
            {
                f[i * (N + 2) + j] = 0.0;
            }
        }
    }
}
