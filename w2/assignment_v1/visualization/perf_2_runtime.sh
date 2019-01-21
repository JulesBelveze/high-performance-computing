#!/bin/bash
#BSUB -J test1
#BSUB -q hpcintro
#BSUB -W 2000000 -R "rusage[mem=512MB]"
#BSUB -n 1

#N=(2 4 8 16 32 64 128 256 512 1024 2048)
version=(2 6 7)
n=1000
k=10000
d=0.0001

echo "cleaning and making"
make -f Makefile.HPC clean
make -f Makefile.HPC
echo "Starting Jobs"
timestamp=`date +"%T"`
# mkdir "results/${timestamp}"

for t in 1 2 4 8; do
	for v in "${version[@]}"; do
		# touch "results/${timestamp}/${n}.txt"
		# ./bin/jacob_gauss.gcc-8 0 $n 1000 0.0001 >> "results/${timestamp}/${n}.txt"
		sleep 0.1
		echo OMP_NUM_THREADS=$t /bin/time -f "%e" ./bin/jacob_gauss.gcc $v $n $k $d
		OMP_NUM_THREADS=$t /bin/time -f "%e" ./bin/jacob_gauss.gcc $v $n $k $d
	done
done
echo "DONE"
