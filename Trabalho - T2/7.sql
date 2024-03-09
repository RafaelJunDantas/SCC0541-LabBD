--7
select cities.name, cities.num_cities, air.num_airports
	from
		(select ct.name, count(distinct(gc.geonameid)) as num_cities
   	 		from geocities15k gc join countries ct on gc.country = ct.code
		   	 join circuits c on c.country = ct.name
		   	 group by ct.name) as cities 
		join
		(select ct.name, count(distinct(a.ident)) as num_airports
		   	 from airports a join countries ct on a.isocountry = ct.code
		   	 join circuits c on c.country = ct.name
		   	 group by ct.name) as air
    	on air.name = cities.name;