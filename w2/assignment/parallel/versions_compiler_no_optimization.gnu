file1= "unoptimized/naive.txt"
file2 = "unoptimized/v2.txt"
file3 = "unoptimized/v3.txt"
file4 = "unoptimized/v4.txt"
file5 = "unoptimized/v5.txt"

set terminal jpeg size 900,600 enhanced font 'Computer modern,12' dashlength 2.0

set tmargin at screen 0.90
set bmargin at screen 0.13
set  rmargin at screen 0.94
set lmargin at screen 0.15
symbsize=1.2
set yrange [0:8]
set xrange [0:8]

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


set xlabel "Threads"
set ylabel "S(P)"
set size 1,1
set key left top
set terminal jpeg
set output "S(P)_different_versions_compiler_optim.jpeg"


plot file1 using ($2):(2.17/$1) with linespoints ls 3 title "Naive", x with lines ls 2 title "Ideal", file2 using ($2):(2.06/$1) with linespoints ls 4 title "Version 2", file3 using ($2):(2.18/$1) with linespoints ls 1 title "Version 3",file4 using ($2):(2.18/$1) with linespoints ls 5 title "Version 4",file5 using ($2):(2.18/$1) with linespoints ls 6 title "Version 5"
