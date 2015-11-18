set terminal png size 1200, 800
set title "duration"
set datafile separator comma
set output "taskduration.png"
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%Y-%m-%d\n%H:%M:%S"
set ylabel "seconds\nlog scale"
set logscale y 10
#set xtics rotate by 45
plot "taskduration.csv" using 1:2 title 'duration' with points pointtype 7 pointsize 1
