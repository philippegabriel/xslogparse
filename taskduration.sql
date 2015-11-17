select min(time) as start,extract (epoch from age(max(time),min(time))) as duration , taskid from xensource 
	where taskid in 
		(select distinct(taskid) from xensource)
group by taskid 
order by start;

