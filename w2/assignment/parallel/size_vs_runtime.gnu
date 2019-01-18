file1= "size/1.txt"
file2 = "size/2.txt"
file3 = "size/4.txt"
file4 = "size/8.txt"

set terminal jpeg size 1900,1600 enhanced font 'Computer modern,24' dashlength 2.0

set tmargin at screen 0.90
set bmargin at screen 0.13
set rmargin at screen 0.94
set lmargin at screen 0.15
symbsize=1.2
# set yrange [0:8]
# set xrange [0:8]

set style line 1 lt 2 lc rgb "orange" pt 6 lw 2.5
set style line 2 dt 1 lc rgb "red" pt 4 lw 2.5
set style line 3 dt 1 lc rgb "blue" pt 3 lw 2.5
set style line 4 dt 1 lc rgb "green" pt 4 lw 2.5
set style line 5 dt 1 lc rgb "black" pt 5 lw 2.5
set style line 6 dt 1 lc rgb "yellow" pt 6 lw 2.5


set size 1,1
set border lw 2.0
set pointsize 1
set bars 1


set xlabel "Memory (kb)"
set ylabel "Runtime (s)"
set size 1,1
set key left top
set terminal jpeg
set output "size_vs_runtime.jpeg"


plot file1 using ($2/1000):($1) with linespoints ls 3 title "1 Thread", file2 using ($2/1000):($1) with linespoints ls 4 title "2 Threads", file3 using ($2/1000):($1) with linespoints ls 1 title "4 Threads",file4 using ($2/1000):($1) with linespoints ls 5 title "8 Threads"

