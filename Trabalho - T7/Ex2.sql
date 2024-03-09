--exercicio 2

drop materialized view aeroportos_sem_cidade;

create materialized view aeroportos_sem_cidade as
	select c.continent, c.name as country_name, 
			a.name as airport_name, a.latdeg as lat, a.longdeg as lon
		from countries c 
		join airports a on a.isocountry = c.code 
		where c.code = 'BR' and a.city is null;
	
select * from aeroportos_sem_cidade;
	
drop materialized view cidades_brasileiras;

create materialized view cidades_brasileiras as 
	select gc.name as city_name, gc.population, gc.lat, gc.long as lon
		from geocities15k gc
		where gc.population >= 100000 and gc.country = 'BR';

select * from cidades_brasileiras;
		
CREATE EXTENSION IF NOT EXISTS Cube; 
CREATE EXTENSION IF NOT EXISTS EarthDistance;

select a.airport_name, c.city_name, c.population, 
		earth_distance(ll_to_earth(a.lat, a.lon), ll_to_earth(c.lat, c.lon)) as dist
	from aeroportos_sem_cidade a, cidades_brasileiras c
	where earth_distance(ll_to_earth(a.lat, a.lon), ll_to_earth(c.lat, c.lon)) <= 10000;