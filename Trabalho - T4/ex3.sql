--exercicio 3

select distinct(r.name) as race_name, r.year, d.forename || ' ' || d.surname as name, re.position,
	avg(p.milliseconds) over(partition by r.raceid, re.raceid, p.raceid, d.driverid, re.driverid, p.driverid) as average_pit_stops
	from races r
	join pitstops p on p.raceid = r.raceid
	join driver d on d.driverid = p.driverid 
	join results re on re.driverid = p.driverid and re.raceid = p.raceid 
	order by average_pit_stops;

--confirmar os resultados
/*
select r.name as race_name, r.year, d.forename || ' ' || d.surname as name, 
	avg(p.milliseconds) as average_pit_stops
	from races r 
	join pitstops p on p.raceid = r.raceid and r.year = 2011 and r.name = 'Abu Dhabi Grand Prix'
	join driver d on d.driverid = p.driverid
	group by r.year, r.name, d.forename, d.surname
	order by average_pit_stops;
*/