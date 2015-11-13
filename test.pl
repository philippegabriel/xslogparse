#!/usr/bin/perl
#Nov  6 09:22:07 2r188x11 xapi: [debug|2r188x11|192 pool_db_sync|Pool DB sync D:01b05b091868|pool_db_sync] Starting DB sync
#Nov  6,09:22:08,2r188x11,xapi:,debug,2r188x11,12502557,INET 0.0.0.0:80,,dummytaskhelper task dispatch:event.from D:21f2ee1eda3f created by task D:7aaf69b26f63
#Pool DB sync D:01b05b091868
$i=0;
while(<>){
#line number
$i++;
chomp;
#sanitise input, remove comma
s/\,/\./g;
#extract syslog entries
/^(...\s+\d{1,2})\s+(.*?)\s+(.*?)\s+(.*?)$/ or die "bad format at line:$i\n$_\n";
($date,$time,$host,$msg)=($1,$2,$3,$4);
#check for repeated messages
if($msg =~ /last message repeated/){
	$xapimsg=$msg;}
else{
	$msg =~ /^(.*?)\s+(.*?)$/ or die "bad format at line:$i\n$_\n";
	($pgm,$msg)=($1,$2);
#subst [,],| for comma in xapi header
#[debug|2r188x11|192 pool_db_sync|Pool DB sync D:01b05b091868|mscgen] xapi=>xapi [label="(XML)"];
$msg =~ /^.*?\[(.*?)\|(.*?)\|(.*?)\|(.*?)\|(.*?)\](.*?)$/ or die "bad format at line:$i\n$_\n";
($level,$host2,$domain,$task,$process,$xapimsg)=($1,$2,$3,$4,$5,$6);
#extract fields
if($task eq ''){
	($taskname,$tasktype,$taskid)=('','','')}
else{
	$task =~ /(.+?)([RD]):([[:xdigit:]]{12})/;
	($taskname,$tasktype,$taskid)=($1,$2,$3)}
}
print "$date,$time,$host,$pgm,$level,$host2,$domain,$taskname,$tasktype,$taskid,$process,$xapimsg\n";
}
