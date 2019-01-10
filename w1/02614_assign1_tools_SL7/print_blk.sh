# BSUB -J blk
# BSUB -o blk_%J.out
# BSUB -e blk_%J.err
# BSUB -q hpcintro
# BSUB -W 200 -R "rusage[mem=5012MB]"

# run matmult_c for different matrix size
# for i in `seq 100 100 2000`
# do
#     start=`date +%s%3N`
#     ./matmult_c.gcc knm $i $i $i
#     end=`date +%s%3N`
#     runtime=$((end-start))
#     echo $runtime
# done

# data with different block size
for i in `seq 0 10 300`
do
    ./matmult_c.gcc blk 1250 1250 1250 $i
    ./matmult_c.gcc blk 1500 1500 1500 $i
    ./matmult_c.gcc blk 1750 1750 1750 $i
    echo " "
done
