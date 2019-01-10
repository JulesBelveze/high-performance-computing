for i in `seq 100 20 2000`
do
    ./matmult_c.gcc knm $i $i $i
done

