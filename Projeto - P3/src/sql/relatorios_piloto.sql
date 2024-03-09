--relatorios piloto

--relatorio 5
--consultar a quantidade de vitorias obtidas, apresentando
--o ano e a corrida onde cada vitoria foi alcancada

drop function if exists report5;

create or replace function report5(piloto text)
	returns table(ano int4, race_name text, wins int8) as $$
	declare id integer;
	begin	
		select into id driverid from driver where driverref = piloto;
		return query
			select rc.year, rc.name, count(*) as wins
				from results r
				join races rc on rc.raceid = r.raceid 
				where r.driverid = id
				group by rollup(rc.year, rc.name)
				order by wins desc;
	end;
	$$language plpgsql;

--teste
select report5('hamilton');

---------------------------------

--relatorio 6
--liste a quantidade de resultados por cada status,
--apresentando o status e sua contagem, limitado ao piloto logado

drop function if exists report6;

create or replace function report6(piloto text)
	returns table(status text, total int8) as $$
	declare id integer;
	begin	
		select into id driverid from driver where driverref = piloto;
		return query
			select s.status, count(s.status) as total
				from results r 
				join status s on s.statusid = r.statusid 
				where r.driverid = id
				group by s.status;
	end;
	$$language plpgsql;

--teste
select report6('hamilton');