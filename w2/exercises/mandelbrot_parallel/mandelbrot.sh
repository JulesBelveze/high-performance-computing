#!/bin/bash
#BSUB -J mandelbrot
#BSUB -o mandelbrot%J.out
#BSUB -e mandelbrot%J.err
#BSUB -q hpcintro
#BSUB -W 2000000 -R "rusage[mem=512MB]"
#BSUB -n 1

echo "Starting Jobs"
timestamp=`date +"%T"`

COMPILER_OPTIONS=(Og Ofast Oxloopinfo Oxopenmp)

FUNCTIONS=(mandel)

mkdir "${timestamp}"
for c in "${COMPILER_OPTIONS[@]}"; do
	make clean
	COMPILER_OPTIONS=-$c make
	mkdir ${timestamp}/${c}
		for f in "${FUNCTIONS[@]}"; do
			mkdir ${timestamp}/${c}/${f}
			for i in `seq 1 80 2000`;do
      	for j in `seq 1 1 5`;do
				  ./mandelbrot ${f} $i $i $i >>${timestamp}/${c}/${f}/${i}_${j}.txt 2>&1
        done
			done
	done
done
echo "DONE"
