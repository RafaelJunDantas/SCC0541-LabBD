--exercicio 1

drop materialized view aeroportos_brasileiros;

create materialized view aeroportos_brasileiros as
	select c.continent, c.name as country_name, 
			gc.name as city_name, gc.population, 
			a.name as airport_name, a.latdeg as lat, a.longdeg as lon
		from countries c 
		join geocities15k gc on c.code = gc.country 
		join airports a on a.city = gc.name
		where a.isocountry = 'BR'
		order by gc.name;
	
select * from aeroportos_brasileiros;

select count(*) from aeroportos_brasileiros;