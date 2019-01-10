#!/bin/bash
#BSUB -J matmult
#BSUB -o matmult_%J.out
#BSUB -e matmult_%J.err
#BSUB -q hpcintro
#BSUB -W 200 -R "rusage[mem=5012MB]"

timestamp=`date +"%T"`

COMPILER_OPTIONS=(O0 O1 O2 O3 Os Og Ofast)

FUNC=(mnk mkn nmk nkm kmn knm)

mkdir "${timestamp}"
for f in "${FUNC}"; do
	mkdir ${timestamp}/${f}
	for c in "${COMPILER_OPTIONS[@]}"; do
		mkdir ${timestamp}/${f}/${c}
		for i in `seq 1 80 2000`;do
			make clean
			COMPILER_OPTIONS=-$c make
			./matmult_c.gcc ${f} $i $i $i >>${timestamp}/${f}/${c}/${i}.txt 2>&1
		done
	done
done