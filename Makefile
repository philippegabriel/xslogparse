#!/usr/bin/make -f
.PHONY: login test clean reallyclean
#PostgreSQL server params, read from .config file
config:=config.xslogparse/.config

seq:=$(shell seq 10 33)
lextargets:=$(foreach i,$(seq),xensource.log.$(i).lex)
csvtargets:=$(foreach i,$(seq),xensource.log.$(i).csv)

all: xensource.csv
xensource.lex: $(lextargets)
	cat $^ | sort | uniq -c >$@
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
initdb:
	source $(config) ; psql -f schema.sql
copytables:
	source $(config) ; psql -c "\copy xensource from xensource.csv with CSV;" 
resetdb:
	source $(config) ; psql -f reset.table.sql
test:
	@echo $(csvtargets)
clean:
	rm -f xensource.lex xensource.ranked.lex xensource.csv
reallyclean: clean
	rm -f $(lextargets) $(csvtargets)

