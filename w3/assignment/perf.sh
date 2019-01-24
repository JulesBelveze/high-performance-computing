#BSUB -J compare_all_gpu
#BSUB -o compare_all_gpu_%J.out
#BSUB -e compare_all_gpu_%J.err
#BSUB -q hpcintrogpu
#BSUB -gpu "num=1:mode=exclusive_process:mps=yes"
#BSUB -n 20
#BSUB -W 59
#BSUB -R "span[hosts=1]"
#BSUB -R "rusage[mem=3000MB]"

module load cuda/10.0
EXECUTABLE=matmult_f.nvcc

SIZES="320 640 1280 2560 5120 10240"

# First round: lib
for i in $SIZES
do
    for j in `seq 1 1 3`
    do
        MFLOPS_MAX_IT=1 ./$EXECUTABLE lib $i $i $i
    done
done

for i in $SIZES
do
    for j in `seq 1 1 3`
    do
        MFLOPS_MAX_IT=1 ./$EXECUTABLE gpu2 $i $i $i
    done
done

for i in $SIZES
do
    for j in `seq 1 1 3`
    do
        MFLOPS_MAX_IT=1 ./$EXECUTABLE gpu3 $i $i $i
    done
done

for i in $SIZES
do
    for j in `seq 1 1 3`
    do
        MFLOPS_MAX_IT=1 ./$EXECUTABLE gpu4 $i $i $i
    done
done

for i in $SIZES
do
    for j in `seq 1 1 3`
    do
        MFLOPS_MAX_IT=1 ./$EXECUTABLE gpu5 $i $i $i
    done
done

for i in $SIZES
do
    for j in `seq 1 1 3`
    do
        MFLOPS_MAX_IT=1 ./$EXECUTABLE gpulib $i $i $i
    done
done
