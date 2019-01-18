file1= "jacobi_speed.txt"
file2 = "gauss_speed.txt"

set terminal jpeg size 900,600 enhanced font 'Computer modern,12' dashlength 2.0

set tmargin at screen 0.90
set bmargin at screen 0.13
set rmargin at screen 0.94
set lmargin at screen 0.15
symbsize=1.2
set yrange [0:50000]
set xrange [100:2000]

set style line 1 lt 2 lc rgb "orange" pt 6 lw 2.5
set style line 2 dt 1 lc rgb "red" pt 4 lw 2.5
set style line 3 dt 1 lc rgb "blue" pt 3 lw 2.5
set style line 4 dt 1 lc rgb "green" pt 4 lw 2.5
set style line 5 dt 1 lc rgb "black" pt 5 lw 2.5
set style line 6 dt 1 lc rgb "yellow" pt 6 lw 2.5


set size 1,1
set border lw 2.0
set pointsize 0.8
set bars 0.5
set logscale x

set xlabel "Matrix Size"
set ylabel "Speed"
set size 1,1
set key right top
set terminal jpeg
set output "speed_vs_matrix_size.jpeg"


plot file1 using ($1):($2/$3) with lines ls 3 title "jacobi", file2 using ($1):($2/$3) with lines ls 4 title "gauss"
