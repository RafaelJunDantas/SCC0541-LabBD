--exercicio 5

drop view correcao_circuitos;

create or replace view correcao_circuitos as
	select c.name as circuit_name, c.location as circuit_location, c.country
		from circuits c  
		where c.country = 'UK' or c.country = 'USA' or c.country = 'Korea' or c.country = 'UAE';

select * from correcao_circuitos order by circuit_name;
