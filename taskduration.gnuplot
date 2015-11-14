set terminal png size 1200, 800
set title "duration"
set datafile separator ","
set output "taskduration.png"
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
#set ydata time
#set timefmt "%H:%M:%S"
plot "test.csv" using 1:2 title 'duration' with points pointtype 7 pointsize 1
