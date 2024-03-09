--overview escuderia

-----------------------------------------------

--busca de um piloto por forename
--consultar se certo piloto ja correu pela escuderia

drop function if exists consultar_piloto;

create or replace function consultar_piloto(escuderia text, piloto text)
	returns table(nome text, data_nascimento date, nacionalidade text) as $$
	declare id integer;
	begin
		select into id constructorid from constructors where constructorref = escuderia;
		return query
			select distinct(d.forename || ' ' || d.surname) as nome, d.dob as data_nascimento, d.nationality 
				from results r
				join driver d on d.driverid = r.driverid 
				where r.constructorid = id and d.forename = piloto
				order by nome;
	end;
	$$language plpgsql;

--teste
select consultar_piloto('mclaren', 'Lewis');

-----------------------------------------------

--quantidade total de vitorias de uma escuderia

drop function if exists total_wins_constructors;

create or replace function total_wins_constructors(nameref text)
	returns integer as $$
	declare total integer;
	begin
		select into total count(*) 
			from constructors c
			join results r on c.constructorid = r.constructorid
			where r.position = 1 and c.constructorref = nameref;
		return total;
	end;
	$$ language plpgsql;

--teste
select total_wins_constructors('mclaren');

-----------------------------------------------

--quantidade de pilotos diferentes que correram pela escuderia

drop function if exists total_drivers_constructors;

create or replace function total_drivers_constructors(nameref text)
	returns integer as $$
	declare total integer;
	begin
		select into total count(distinct(d.driverid))
			from constructors c
			join results r on r.constructorid = c.constructorid
			join driver d on d.driverid = r.driverid 
			where c.constructorref = nameref;
		return total;
	end;
	$$ language plpgsql;

--teste
select total_drivers_constructors('mclaren');

-----------------------------------------------

--primeiro e ultimo ano em que ha dados da escuderia

drop function if exists first_last_year_constructors;

create or replace function first_last_year_constructors(nameref text)
	returns table(primeiro integer, ultimo integer) as $$
	begin
		return query
			select min(rc.year) as first_year, max(rc.year) as last_year
				from constructors c
				join results r on r.constructorid = c.constructorid
				join races rc on rc.raceid = r.raceid 
				where c.constructorref = nameref;
	end;
	$$ language plpgsql;

--teste
select first_last_year_constructors('mclaren');