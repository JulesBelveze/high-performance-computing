#!/bin/bash
#BSUB -J matmult
#BSUB -o matmult_%J.out
#BSUB -e matmult_%J.err
#BSUB -q hpcintro
#BSUB -W 2000000 -R "rusage[mem=5012MB]"

timestamp=`date +"%T"`

COMPILER_OPTIONS=(O0 O1 O2 O3 Os Og Ofast)

FUNCTIONS=(mnk mkn nmk nkm kmn knm)

mkdir "${timestamp}"
for c in "${COMPILER_OPTIONS[@]}"; do
	mkdir ${timestamp}/${c}
		for f in "${FUNCTIONS[@]}"; do
			echo $f
			mkdir ${timestamp}/${c}/${f}
			for i in `seq 1 80 2000`;do
				make clean
				COMPILER_OPTIONS=-$c make
				./matmult_c.gcc ${f} $i $i $i >>${timestamp}/${c}/${f}/${i}.txt 2>&1 & WAITPIDS="$WAITPIDS "$!
			done
	done
	echo $WAITPIDS
	wait $WAITPIDS
	echo "DONE"
done