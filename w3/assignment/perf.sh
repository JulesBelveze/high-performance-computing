#BSUB -J compare_lib_gpu1
#BSUB -o compare_lib_gpu1_%J.out
#BSUB -e compare_lib_gpu1_%J.err
#BSUB -q hpcintrogpu
#BSUB -gpu "num=1:mode=exclusive_process:mps=yes"
#BSUB -n 20
#BSUB -W 10
#BSUB -R "span[hosts=1]"
#BSUB -R "rusage[mem=512MB]"

module load cuda/10.0
EXECUTABLE=matmult_f.nvcc
### export MFLOPS_MAX_IT=1

SIZES="10 30 50 100 150 200 250 300 400 500"

# First round: lib
for i in $SIZES
do
    ./$EXECUTABLE lib $i $i $i
done

# Second round: gpu1
for i in $SIZES
do
    ./$EXECUTABLE gpu1 $i $i $i
done
