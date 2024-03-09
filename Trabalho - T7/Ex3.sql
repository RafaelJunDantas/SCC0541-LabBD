--exercicio 3

drop view circuitos_completa;

create or replace view circuitos_completa as
	select c.name as ciruit_name, c.location as circuit_location, c.country, 
			ct.code as country_code, ct.continent 
		from circuits c 
		left join countries ct on c.country = ct.name
		order by c.name;

select * from circuitos_completa;

select count(*) from circuitos_completa;