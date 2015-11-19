#!/usr/bin/make -f
.PHONY: login test clean reallyclean
#PostgreSQL server params, read from .config file
config:=config.xslogparse/.config

seq:=$(shell seq 10 33)
lextargets:=$(foreach i,$(seq),xensource.log.$(i).lex)
csvtargets:=$(foreach i,$(seq),xensource.log.$(i).csv)
tasks:=VDI.create VDI.attach VBD.create VBD.plug VM.clean_shutdown VM.destroy VM.start all
querytargets:=$(foreach i,$(tasks),duration.$i.csv)
plottargets:=$(subst .csv,.png,$(querytargets))
all: xensource.csv
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
xensource.csv: $(csvtargets)
	cat $^ >$@
login:
	source $(config) ; psql
initdb: schema.db
	source $(config) ; psql -f $<
copytables: xensource.csv
	source $(config) ; psql -c "\copy xensource from xensource.csv with CSV;" 
resetdb: reset.table.db
	source $(config) ; psql -f $<
duration.%.csv : duration.sql
	source $(config) ; psql --field-separator="," --no-align --pset footer=off --variable=TASK="$*" -f $< -o $@
%.png: %.csv
	gnuplot -e "outfile='$@';infile='$<'" duration.gnuplot
query: $(querytargets)
plot: $(plottargets) 
test:
	@echo $(csvtargets)
deploy:
	source $(config) ; scp *.png *.html $$WWW
qclean:
	rm -f $(querytargets)
pclean:
	rm -f $(plottargets)
clean:
	rm -f xensource.lex xensource.ranked.lex xensource.csv
reallyclean: clean
	rm -f $(lextargets) $(csvtargets)
