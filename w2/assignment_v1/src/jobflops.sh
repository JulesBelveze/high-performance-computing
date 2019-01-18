#!/bin/bash
#BSUB -J speed_vs_nb_threads_unopt
#BSUB -o speed_vs_nb_threads_unopt%J.out
#BSUB -e speed_vs_nb_threads_unopt%J.err
#BSUB -q hpcintro
#BSUB -W 2000000 -R "rusage[mem=512MB]" "span=[hosts=1]"
#BSUB -n 10


file="speed_vs_nb_threads_unopt"
mkdir "speed_vs_nb_threads_unopt"

i=1000

OMP_NUM_THREADS=1 time -f "%e" ./bin/jacob_gauss.gcc 6 $i 10000 0.001 >>${file}/6.txt 2>&1
OMP_NUM_THREADS=2 time -f "%e" ./bin/jacob_gauss.gcc 6 $i 10000 0.001 >>${file}/6.txt 2>&1
OMP_NUM_THREADS=4 time -f "%e" ./bin/jacob_gauss.gcc 6 $i 10000 0.001 >>${file}/6.txt 2>&1
OMP_NUM_THREADS=8 time -f "%e" ./bin/jacob_gauss.gcc 6 $i 10000 0.001 >>${file}/6.txt 2>&1

OMP_NUM_THREADS=1 time -f "%e" ./bin/jacob_gauss.gcc 8 $i 10000 0.001 >>${file}/8.txt 2>&1
OMP_NUM_THREADS=2 time -f "%e" ./bin/jacob_gauss.gcc 8 $i 10000 0.001 >>${file}/8.txt 2>&1
OMP_NUM_THREADS=4 time -f "%e" ./bin/jacob_gauss.gcc 8 $i 10000 0.001 >>${file}/8.txt 2>&1
OMP_NUM_THREADS=8 time -f "%e" ./bin/jacob_gauss.gcc 8 $i 10000 0.001 >>${file}/8.txt 2>&1

OMP_NUM_THREADS=1 time -f "%e" ./bin/jacob_gauss.gcc 5 $i 10000 0.001 >>${file}/5.txt 2>&1
OMP_NUM_THREADS=2 time -f "%e" ./bin/jacob_gauss.gcc 5 $i 10000 0.001 >>${file}/5.txt 2>&1
OMP_NUM_THREADS=4 time -f "%e" ./bin/jacob_gauss.gcc 5 $i 10000 0.001 >>${file}/5.txt 2>&1
OMP_NUM_THREADS=8 time -f "%e" ./bin/jacob_gauss.gcc 5 $i 10000 0.001 >>${file}/5.txt 2>&1

OMP_NUM_THREADS=1 time -f "%e" ./bin/jacob_gauss.gcc 4 $i 10000 0.001 >>${file}/4.txt 2>&1
OMP_NUM_THREADS=2 time -f "%e" ./bin/jacob_gauss.gcc 4 $i 10000 0.001 >>${file}/4.txt 2>&1
OMP_NUM_THREADS=4 time -f "%e" ./bin/jacob_gauss.gcc 4 $i 10000 0.001 >>${file}/4.txt 2>&1
OMP_NUM_THREADS=8 time -f "%e" ./bin/jacob_gauss.gcc 4 $i 10000 0.001 >>${file}/4.txt 2>&1

OMP_NUM_THREADS=1 time -f "%e" ./bin/jacob_gauss.gcc 2 $i 10000 0.001 >>${file}/2.txt 2>&1
OMP_NUM_THREADS=2 time -f "%e" ./bin/jacob_gauss.gcc 2 $i 10000 0.001 >>${file}/2.txt 2>&1
OMP_NUM_THREADS=4 time -f "%e" ./bin/jacob_gauss.gcc 2 $i 10000 0.001 >>${file}/2.txt 2>&1
OMP_NUM_THREADS=8 time -f "%e" ./bin/jacob_gauss.gcc 2 $i 10000 0.001 >>${file}/2.txt 2>&1

OMP_NUM_THREADS=1 time -f "%e" ./bin/jacob_gauss.gcc 0 $i 10000 0.001 >>${file}/0.txt 2>&1
OMP_NUM_THREADS=2 time -f "%e" ./bin/jacob_gauss.gcc 0 $i 10000 0.001 >>${file}/0.txt 2>&1
OMP_NUM_THREADS=4 time -f "%e" ./bin/jacob_gauss.gcc 0 $i 10000 0.001 >>${file}/0.txt 2>&1
OMP_NUM_THREADS=8 time -f "%e" ./bin/jacob_gauss.gcc 0 $i 10000 0.001 >>${file}/0.txt 2>&1
