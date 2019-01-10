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
for i in `seq 1 10 151`
do
    ./matmult_c.gcc blk 1500 1500 1500 $i
    ./matmult_c.gcc blk 1750 1750 1750 $i
    ./matmult_c.gcc blk 2000 2000 2000 $i
    echo " "
done
