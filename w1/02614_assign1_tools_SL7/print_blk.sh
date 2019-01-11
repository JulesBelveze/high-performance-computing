# BSUB -J blk
# BSUB -o blk_%J.out
# BSUB -e blk_%J.err
# BSUB -q hpcintro
# BSUB -W 20000000 -R "rusage[mem=5012MB]"

make clean
make

# folder="permut_opt_"
# mkdir "permut_opt_"
# # run matmult_c for different matrix size
# for i in `seq 36 50 1000`
# do
#     echo $i
#     for j in `seq 1 1 5`
#     do
#         ./matmult_c.gcc knm $i $i $i >>${folder}/knm.txt 2>&1
#         ./matmult_c.gcc kmn $i $i $i >>${folder}/kmn.txt 2>&1
#         ./matmult_c.gcc mnk $i $i $i >>${folder}/mnk.txt 2>&1
#         ./matmult_c.gcc mkn $i $i $i >>${folder}/mkn.txt 2>&1
#         ./matmult_c.gcc nkm $i $i $i >>${folder}/nkm.txt 2>&1
#         ./matmult_c.gcc nmk $i $i $i >>${folder}/nmk.txt 2>&1
#     done
# done

# data with different block size
#
# folder="block"
# mkdir "block"
#
# for i in `seq 0 25 800`
# do
#     for j in `seq 1 1 5`
#     do
#         ./matmult_c.gcc blk 1000 1000 1000 $i >>${folder}/1000.txt 2>&1
#         ./matmult_c.gcc blk 1500 1500 1500 $i >>${folder}/1500.txt 2>&1
#         ./matmult_c.gcc blk 2000 2000 2000 $i >>${folder}/2000.txt 2>&1
#     done
# done

# data for a fixed bs (300) and collecting mflops against matrix size
folder="blk"
mkdir "blk"

for i in `seq 36 50 2500`
do
    for j in `seq 1 1 10`
    do
        ./matmult_c.gcc blk $i $i $i 300 >>${folder}/block_300.txt 2>&1
        # ./matmult_c.gcc mkn $i $i $i >>${folder}/mnk_no_block.txt 2>&1
    done
done
