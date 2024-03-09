--exercicio 5
	
select distinct(r.raceid) as race_id, r.name as race_name, r.year,
	max(re.milliseconds) over(partition by r.raceid, re.raceid) as race_total_time,
	d.forename || ' ' || d.surname as driver_name, re.milliseconds,
	re.milliseconds - lag(re.milliseconds, 1) over(partition by r.raceid, re.raceid order by re.milliseconds) as disadvantage_next_driver,
	re.milliseconds - min(re.milliseconds) over(partition by r.raceid, re.raceid) as disadvantage_first
	from races r 
	join results re on re.raceid = r.raceid and re.statusid = 1 --status 1 == finished
	join driver d on d.driverid = re.driverid;