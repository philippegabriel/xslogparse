#!/usr/bin/perl
#xensource log is: <syslog entries><xapi header><xapi msg>
#e.g.
#Nov  6 09:22:07 2r188x11 xapi: [debug|2r188x11|12548463 UNIX /var/xapi/xapi|session.slave_login D:5ca21c49eef6|mscgen] xapi=>xapi [label="(XML)"];
#
#This script extract the xapi msg and attempt to identify mutable fields
while(<>){
#find mesg
s/^.*?\](.*)$/\1/;
#ipv6 address e.g. fdac:fcf1:05f2:2352:0812:171b:0fb6:c7d4
s/[[:xdigit:]]{4}:[[:xdigit:]]{4}:[[:xdigit:]]{4}:[[:xdigit:]]{4}:[[:xdigit:]]{4}:[[:xdigit:]]{4}:[[:xdigit:]]{4}:[[:xdigit:]]{4}/<ipv6>/g;
#subst ref
s/[[:xdigit:]]{2,12}-[[:xdigit:]]{2,12}-[[:xdigit:]]{2,12}-[[:xdigit:]]{2,12}-[[:xdigit:]]{2,12}/<ref>/g;
#mac address e.g. de:d3:82:01:02:49
s/[[:xdigit:]]{2}:[[:xdigit:]]{2}:[[:xdigit:]]{2}:[[:xdigit:]]{2}:[[:xdigit:]]{2}:[[:xdigit:]]{2}/<mac>/g;
#subst hex
s/[[:xdigit:]]{6,}/<hex>/g;
#get rid of nums
s/\d+/<int>/g;
print $_;
}

