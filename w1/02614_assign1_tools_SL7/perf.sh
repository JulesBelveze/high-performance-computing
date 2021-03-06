#!/bin/bash
#BSUB -J matmult
#BSUB -o matmult_%J.out
#BSUB -e matmult_%J.err
#BSUB -q hpcintro
#BSUB -W 2000000 -R "rusage[mem=512MB]"
#BSUB -n 1

echo "Starting Jobs"
timestamp=`date +"%T"`

COMPILER_OPTIONS=(O0 O1 O2 O3 Os Og Ofast)

FUNCTIONS=(mnk mkn nmk nkm kmn knm)

mkdir "${timestamp}"
for c in "${COMPILER_OPTIONS[@]}"; do
	make clean
	COMPILER_OPTIONS=-$c make
	mkdir ${timestamp}/${c}
		for f in "${FUNCTIONS[@]}"; do
			mkdir ${timestamp}/${c}/${f}
			for i in `seq 1 80 2000`;do
      	for j in `seq 1 1 5`;do
				  ./matmult_c.gcc ${f} $i $i $i >>${timestamp}/${c}/${f}/${i}_${j}.txt 2>&1
        done
			done
	done
done
echo "DONE"