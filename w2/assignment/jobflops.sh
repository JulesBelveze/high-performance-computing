#!/bin/bash
#BSUB -J matmult
#BSUB -o matmult_%J.out
#BSUB -e matmult_%J.err
#BSUB -q hpcintro
#BSUB -W 2000000 -R "rusage[mem=512MB]"
#BSUB -n 1

# echo "Starting Jobs"
# timestamp=`date +"%T"`
# ls
# mkdir "results/${timestamp}"
# for n in `seq 1 1 10`; do
# 	mkdir "${timestamp}/${c}"
# 	echo ${f} $n
# done
# echo "DONE"
# mkdir "${timestamp}"
# for c in "${COMPILER_OPTIONS[@]}"; do
# 	make clean
# 	COMPILER_OPTIONS=-$c make
# 	mkdir ${timestamp}/${c}
# 		for f in "${FUNCTIONS[@]}"; do
# 			mkdir ${timestamp}/${c}/${f}
# 			for i in `seq 1 80 2000`;do
#       	for j in `seq 1 1 5`;do
# 					echo ${f} $i $i $i >>${timestamp}/${c}/${f}/${i}_${j}.txt 2>&1
# 				  # ./matmult_c.gcc ${f} $i $i $i >>${timestamp}/${c}/${f}/${i}_${j}.txt 2>&1
#         done
# 			done
# 	done
# done
# echo "DONE"

file="mflops_msize"
mkdir "mflops_msize"

for i in 100 500 1000 1500 2000
do
    OMP_NUM_THREADS=1 time -f "%e" ./bin/jacob_gauss.gcc 2 $i 10000 0.001 >>${file}/1thread.txt 2>&1
    OMP_NUM_THREADS=2 time -f "%e" ./bin/jacob_gauss.gcc 2 $i 10000 0.001 >>${file}/2threads.txt 2>&1
    OMP_NUM_THREADS=4 time -f "%e" ./bin/jacob_gauss.gcc 2 $i 10000 0.001 >>${file}/4threads.txt 2>&1
    OMP_NUM_THREADS=8 time -f "%e" ./bin/jacob_gauss.gcc 2 $i 10000 0.001 >>${file}/8threads.txt 2>&1
done
