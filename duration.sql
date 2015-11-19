
select min(time) as start ,taskid,extract (epoch from age(max(time),min(time))) as :"TASK" from xensource 
	where taskid in 
		(select distinct(taskid) from xensource
			where taskname ~ 
				(case :'TASK'
					when 'all' then '.*'
					else :'TASK'
				end)
		)
group by taskid,taskname 
order by start;
