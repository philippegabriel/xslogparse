select min(time) as start ,taskid,strftime('%s',max(time))-strftime('%s',min(time)) as "task" from xensource 
	where taskid in 
		(select distinct(taskid) from xensource
			ifelse(task,`all',`',`where taskname = ' 'task')
		)
group by taskid,taskname 
order by start;
