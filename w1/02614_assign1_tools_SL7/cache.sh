#!/bin/bash
#BSUB -J matmult
#BSUB -o matmult_%J.out
#BSUB -e matmult_%J.err
#BSUB -q hpcintro
#BSUB -W 2000000 -R "rusage[mem=512MB]"
#BSUB -n 1

echo "Starting Jobs"
timestamp=`date +"%T"`_mem

COMPILER_OPTIONS=(O0 Ofast)

FUNCTIONS=(mnk mkn nmk nkm kmn knm)

mkdir "${timestamp}"
for c in "${COMPILER_OPTIONS[@]}"; do
	make clean
	COMPILER_OPTIONS=-$c make
	mkdir ${timestamp}/${c}
		for f in "${FUNCTIONS[@]}"; do
			mkdir ${timestamp}/${c}/${f}
		#	for i in `seq 1 280 2000`;do
				   perf stat -B -e cache-references,cache-misses,cycles,task-clock,instructions,branches,branch-misses,faults,migrations -r 5 ./matmult_c.gcc ${f} 1300 1300 1300  >>${timestamp}/${c}/${f}_1300.txt 2>&1
		#	done
	done
done
echo "DONE"
