# BSUB -J blk
# BSUB -o blk_%J.out
# BSUB -e blk_%J.err
# BSUB -q hpcintro
# BSUB -W 2000000000 -R "rusage[mem=5012MB]"

make clean
make

# run matmult_c for different matrix size
# for i in `seq 100 100 2000`
# do
#     echo "knm"
#     for j in `seq 1 1 5`
#     do
#         ./matmult_c.gcc knm $i $i $i
#     done
#
#     echo "kmn"
#     for j in `seq 1 1 5`
#     do
#         ./matmult_c.gcc kmn $i $i $i
#     done
#
#     echo "mnk"
#     for j in `seq 1 1 5`
#     do
#         ./matmult_c.gcc mnk $i $i $i
#     done
#
#     echo "mkn"
#     for j in `seq 1 1 5`
#     do
#         ./matmult_c.gcc mkn $i $i $i
#     done
#
#     echo "nkm"
#     for j in `seq 1 1 5`
#     do
#         ./matmult_c.gcc nkm $i $i $i
#     done
#
#     echo "nmk"
#     for j in `seq 1 1 5`
#     do
#         ./matmult_c.gcc nmk $i $i $i
#     done
#
#     echo "\n $i"
# done

# data with different block size
for i in `seq 0 10 350`
do
    echo "mat1"
    for j in `seq 1 1 5`
    do
        ./matmult_c.gcc blk 1250 1250 1250 $i
    done

    echo "mat2"
    for j in `seq 1 1 5`
    do
        ./matmult_c.gcc blk 1500 1500 1500 $i
    done

    echo "mat3"
    for j in `seq 1 1 5`
    do
        ./matmult_c.gcc blk 1750 1750 1750 $i
    done
    echo "\n $i"
done
