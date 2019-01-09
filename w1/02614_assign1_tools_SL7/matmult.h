#ifndef __MATMULT_H
#define __MATMULT_H

void matmult_nat(int m,int n,int k,double **A,double **B,double **C);
void matmult_blk(int m,int n,int k,double **A,double **B,double **C, int bs);

#endif
