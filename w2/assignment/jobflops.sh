#!/bin/bash
#BSUB -J matmult
#BSUB -o matmult_%J.out
#BSUB -e matmult_%J.err
#BSUB -q hpcintro
#BSUB -W 2000000 -R "rusage[mem=512MB]" "span=[hosts=1]"
#BSUB -n 10


file="mflops_msize"
mkdir "mflops_msize"

for i in 100 500 1000 1500 2000
do
    OMP_NUM_THREADS=1 time -f "%e" ./bin/jacob_gauss.gcc 6 $i 10000 0.001 >>${file}/1thread_6.txt 2>&1
    OMP_NUM_THREADS=2 time -f "%e" ./bin/jacob_gauss.gcc 6 $i 10000 0.001 >>${file}/2threads_6.txt 2>&1
    OMP_NUM_THREADS=4 time -f "%e" ./bin/jacob_gauss.gcc 6 $i 10000 0.001 >>${file}/4threads_6.txt 2>&1
    OMP_NUM_THREADS=8 time -f "%e" ./bin/jacob_gauss.gcc 6 $i 10000 0.001 >>${file}/8threads_6.txt 2>&1

    OMP_NUM_THREADS=1 time -f "%e" ./bin/jacob_gauss.gcc 8 $i 10000 0.001 >>${file}/1thread_8.txt 2>&1
    OMP_NUM_THREADS=2 time -f "%e" ./bin/jacob_gauss.gcc 8 $i 10000 0.001 >>${file}/2threads_8.txt 2>&1
    OMP_NUM_THREADS=4 time -f "%e" ./bin/jacob_gauss.gcc 8 $i 10000 0.001 >>${file}/4threads_8.txt 2>&1
    OMP_NUM_THREADS=8 time -f "%e" ./bin/jacob_gauss.gcc 8 $i 10000 0.001 >>${file}/8threads_8.txt 2>&1

    OMP_NUM_THREADS=1 OMP_PLACES=cores OMP_PROC_BIND=close time -f "%e" ./bin/jacob_gauss.gcc 8 $i 10000 0.001 >>${file}/1thread_8_params.txt 2>&1
    OMP_NUM_THREADS=2 OMP_PLACES=cores OMP_PROC_BIND=close time -f "%e" ./bin/jacob_gauss.gcc 8 $i 10000 0.001 >>${file}/2threads_8_params.txt 2>&1
    OMP_NUM_THREADS=4 OMP_PLACES=cores OMP_PROC_BIND=close time -f "%e" ./bin/jacob_gauss.gcc 8 $i 10000 0.001 >>${file}/4threads_8_params.txt 2>&1
    OMP_NUM_THREADS=8 OMP_PLACES=cores OMP_PROC_BIND=close time -f "%e" ./bin/jacob_gauss.gcc 8 $i 10000 0.001 >>${file}/8threads_8_params.txt 2>&1

    OMP_NUM_THREADS=1 time -f "%e" ./bin/jacob_gauss.gcc 5 $i 10000 0.001 >>${file}/1thread_5.txt 2>&1
    OMP_NUM_THREADS=2 time -f "%e" ./bin/jacob_gauss.gcc 5 $i 10000 0.001 >>${file}/2threads_5.txt 2>&1
    OMP_NUM_THREADS=4 time -f "%e" ./bin/jacob_gauss.gcc 5 $i 10000 0.001 >>${file}/4threads_5.txt 2>&1
    OMP_NUM_THREADS=8 time -f "%e" ./bin/jacob_gauss.gcc 5 $i 10000 0.001 >>${file}/8threads_5.txt 2>&1

    OMP_NUM_THREADS=1 time -f "%e" ./bin/jacob_gauss.gcc 4 $i 10000 0.001 >>${file}/1thread_4.txt 2>&1
    OMP_NUM_THREADS=2 time -f "%e" ./bin/jacob_gauss.gcc 4 $i 10000 0.001 >>${file}/2threads_4.txt 2>&1
    OMP_NUM_THREADS=4 time -f "%e" ./bin/jacob_gauss.gcc 4 $i 10000 0.001 >>${file}/4threads_4.txt 2>&1
    OMP_NUM_THREADS=8 time -f "%e" ./bin/jacob_gauss.gcc 4 $i 10000 0.001 >>${file}/8threads_4.txt 2>&1

    OMP_NUM_THREADS=1 time -f "%e" ./bin/jacob_gauss.gcc 2 $i 10000 0.001 >>${file}/1thread_2.txt 2>&1
    OMP_NUM_THREADS=2 time -f "%e" ./bin/jacob_gauss.gcc 2 $i 10000 0.001 >>${file}/2threads_2.txt 2>&1
    OMP_NUM_THREADS=4 time -f "%e" ./bin/jacob_gauss.gcc 2 $i 10000 0.001 >>${file}/4threads_2.txt 2>&1
    OMP_NUM_THREADS=8 time -f "%e" ./bin/jacob_gauss.gcc 2 $i 10000 0.001 >>${file}/8threads_2.txt 2>&1

    OMP_NUM_THREADS=1 time -f "%e" ./bin/jacob_gauss.gcc 0 $i 10000 0.001 >>${file}/1thread_0.txt 2>&1
    OMP_NUM_THREADS=2 time -f "%e" ./bin/jacob_gauss.gcc 0 $i 10000 0.001 >>${file}/2threads_0.txt 2>&1
    OMP_NUM_THREADS=4 time -f "%e" ./bin/jacob_gauss.gcc 0 $i 10000 0.001 >>${file}/4threads_0.txt 2>&1
    OMP_NUM_THREADS=8 time -f "%e" ./bin/jacob_gauss.gcc 0 $i 10000 0.001 >>${file}/8threads_0.txt 2>&1

done
