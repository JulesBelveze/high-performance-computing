#!/bin/bash
#BSUB -J jacobi
#BSUB -o jacobi_%J.out
#BSUB -e jacobi_%J.err
#BSUB -q hpcintrogpu
#BSUB -gpu "num=1:mode=exclusive_process:mps=yes"
#BSUB -n 20
#BSUB -W 590
#BSUB -R "span[hosts=1]"
#BSUB -R "rusage[mem=3000MB]"
make
module load cuda/10.0
EXECUTABLE=jacobi_f
SIZES="10 100 320 640 1280 2560 5120 10240 20480"
mkdir -p results

types=(cpu gpu1 gpu2 gpu3)
for type in ${types[*]};do
    for i in $SIZES; do
    for j in `seq 1 1 3`; do
        OMP_NUM_THREADS=12 ./$EXECUTABLE $type $i $i $i > results/${type}_${i}_${j} 2>&1
    done
done
done

