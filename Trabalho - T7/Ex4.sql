--exercicio 4

drop view problemas_circuitos;

create or replace view problemas_circuitos as
	select c.circuit_name, c.circuit_location, c.country
		from circuitos_completa c
		where c.country_code is null;

select * from problemas_circuitos;