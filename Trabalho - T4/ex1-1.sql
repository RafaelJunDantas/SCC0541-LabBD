--exercicio 1

select distinct(r.name, r.year, l.lap) as race_year_lap,
	first_value(d.forename || ' ' || d.surname) over(partition by r.name, r.year, l.lap order by l.milliseconds) as fastest_driver, 
	min(l.milliseconds) over(partition by r.name, r.year, l.lap order by r.year) as min_time,
	first_value(d.forename || ' ' || d.surname) over(partition by r.name, r.year, l.lap order by l.milliseconds desc) as slowest_driver,
	max(l.milliseconds) over(partition by r.name, r.year, l.lap order by r.year) as max_time
	from laptimes l
	join races r on r.raceid = l.raceid
	join driver d on d.driverid = l.driverid;


--confirmar os resultados
select r.name, r.year, l.lap, d.forename || ' ' || d.surname , l.milliseconds
	from driver d 
	join laptimes l on l.driverid = d.driverid and l.lap = 3
	join races r on r.raceid = l.raceid and r.name = '70th Anniversary Grand Prix'
	order by r.year, r.name, l.lap, l.milliseconds desc;