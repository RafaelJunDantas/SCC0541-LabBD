--6
select d.forename, d.surname, count(*) as pole_position 
	from driver d join qualifying q on d.driverid = q.driverid 
	where q.position = 1
	group by d.driverid
	order by pole_position desc 
	limit 1;