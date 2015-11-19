# xslogparse
####Set of scripts to analyse XenServer  xensource.log
ref: http://xenserver.org/partners/developing-products-for-xenserver/20-dev-hints/90-xs-log-debug-understand.html


[`log2csv.pl`](log2csv.pl) parses a xensource.log and generate a xensource.csv file.
This csv file gets uploaded (see: [`Makefile`](Makefile) target:copytables) into a postgresql db defined by [`schema.db`](schema.db).
[`duration.sql`](duration.sql), a parametrised sql query gets invoked (see: [`Makefile`](Makefile) target: query) to generate a set of csv files.
[`duration.gnuplot`](Makefile target: plot) transform them to png files.
----
![diagram](doc/diagram.png)

Sample Graphs:
==============
####Duration of a few selected tasks:
![Duration of tasks](doc/xslogparse.png)
