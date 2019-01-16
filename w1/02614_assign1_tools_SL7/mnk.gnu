file1= "mnk.dat"
file2 = "mkn.dat"
file3 = "nmk.dat"
file4 = "nkm.dat"
file5 = "kmn.dat"
file6 = "knm.dat"
set terminal jpeg size 900,600 enhanced font 'Computer modern,12' dashlength 2.0

set tmargin at screen 0.90
set bmargin at screen 0.13
set rmargin at screen 0.94
set lmargin at screen 0.15
symbsize=1.2
set yrange [0:500]
set xrange [354:65000]

set style line 1 dt 1 lc rgb "orange" lw 2.5
set style line 2 dt 1 lc rgb "red" lw 2.5
set style line 3 dt 1 lc rgb "blue" lw 2.5
set style line 4 dt 1 lc rgb "green" lw 2.5
set style line 5 dt 1 lc rgb "black" lw 2.5
set style line 6 dt 1 lc rgb "yellow" lw 2.5


set size 1,1
set border lw 2.0
set pointsize 0.8
set bars 0.5
set logscale x
set xlabel "Memory footprint (KB)"
set ylabel "Performance (MFlop/s)"
set size 1,1
set key left bottom 
set terminal jpeg
set output "loops.jpeg"


plot file1 using ($1):($2) with lines ls 1 title "mnk", file2 using ($1):($2) with lines ls 2 title "mkn", file3 using ($1):($2) with lines ls 3 title "nmk", file4 using ($1):($2) with lines ls 4 title "nkm", file5 using ($1):($2) with lines ls 5 title "kmn", file6 using ($1):($2) with lines ls 6 title "knm"
