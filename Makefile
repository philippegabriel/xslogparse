#!/usr/bin/make -f
.PHONY: login test clean reallyclean
#PostgreSQL server params, read from .config file
config:=config.xslogparse/.config

seq:=$(shell seq 10 33)
csvinputs:=$(foreach i,$(seq),xensource.log.$(i).csv)
lexinputs:=$(subst .cav,.lex,$(csvtargets))
tasks:=VDI.create VDI.attach VBD.create VBD.plug VM.clean_shutdown VM.destroy VM.start all
sqltargets:=$(foreach i,$(tasks),duration.$i.sql)
csvtargets:=$(subst .sql,.csv,$(sqltargets))
plottargets:=$(subst .csv,.png,$(querytargets))
all: xensource.csv initdb $(csvtargets) $(plottargets)
xensource.lex: $(lextargets)
	cat $^ | sort | uniq -c >$@
xensource.sorted.lex: $(lextargets)
	cat $^ | sort | uniq >$@
xensource.ranked.lex: xensource.lex
	sort -nr $< | perl -pe 's/^\s+(\d+)\s+(.*)$$/\1,\2/' > $@
%.lex: %
	./lexlog.pl $< | sort > $@
%.csv: %
	./log2csv.pl $< >$@
xensource.csv: $(csvinputs)
	cat $^ >$@
initdb: resetdb
	sqlite3 logsdb < schema.db
	sqlite3 logsdb < import.db
resetdb: reset.table.db
	rm -rf logsdb
duration.%.sql: duration.sql.m4
	m4 -D task=$* $< > $@ 
duration.%.csv : duration.%.sql
	sqlite3 --csv logsdb <$< >$@
%.png: %.csv
	gnuplot -e "outfile='$@';infile='$<'" duration.gnuplot
query: $(csvtargets)
plot: $(plottargets) 
test: $(sqltargets)
deploy:
	source $(config) ; scp *.png *.html $$WWW
clean:
	rm -f $(sqltargets) $(csvtargets) $(plottargets)
reallyclean: clean resetdb
	rm -f *.csv *.sql *.lex
