#!/bin/bash
#BSUB -J matmult
#BSUB -o matmult_%J.out
#BSUB -e matmult_%J.err
#BSUB -q hpcintro
#BSUB -W 2000000 -R "rusage[mem=512MB]"
#BSUB -n 1

#N=(2 4 8 16 32 64 128 256 512 1024 2048)
N=(2 4 8 16 32 64 128 256)

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
		./bin/jacob_gauss.gcc-8 0 $n 1000 0.0001 >> "results/${timestamp}/${n}.txt"
		echo $n
done
echo "DONE"
say "DONE"
