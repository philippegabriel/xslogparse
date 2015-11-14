select * from (
	select min(time) as start,max(time)-min(time) as duration , taskid from xensource 
	where taskid in 
		(select distinct(taskid) from xensource)
	group by taskid 
	order by duration desc 
	limit 1000) as toptasks
order by start;

