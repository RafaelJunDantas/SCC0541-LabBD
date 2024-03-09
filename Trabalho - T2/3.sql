--3
select continent, type, count(*) as num_airports
	from airports
	group by continent, type
	order by continent, type;
