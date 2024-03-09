--1
select r.year, d.forename, d.surname, max(ds.points) as total_points
	from driverstandings ds join driver d on ds.driverid = d.driverid 
	join races r on r.raceid = ds.raceid  
	group by r.year, d.forename, d.surname
	order by total_points desc;