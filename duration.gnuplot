set terminal png size 1200, 800
set title infile
set datafile separator ','
set output outfile
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%Y-%m-%d\n%H:%M:%S"
set ylabel "duration in seconds\n(log scale)"
set xlabel "Start of operation"
set key autotitle columnhead
set logscale y 10
plot infile using 1:3 with impulses 
	
