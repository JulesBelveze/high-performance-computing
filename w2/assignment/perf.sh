#!/bin/bash
#BSUB -J matmult
#BSUB -o matmult_%J.out
#BSUB -e matmult_%J.err
#BSUB -q hpcintro
#BSUB -W 2000000 -R "rusage[mem=512MB]"
#BSUB -n 1

N=(2 4 8 16 32 64 128 256 512 1024 2048)

# rm -r "results/"
echo "Starting Jobs"
timestamp=`date +"%T"`
ls
# make clean
# make
mkdir "results/${timestamp}"
# for n in `seq 2 100 1000`; do
	for n in "${N[@]}"; do
		touch "results/${timestamp}/${n}.txt"
		./bin/jacob_gauss.gcc poisson $n 10000 0.00001 >> "results/${timestamp}/${n}.txt"
		echo $n
done
echo "DONE"

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
