--overview piloto

-----------------------------------------------

--quantidade total de vitorias do piloto

drop function if exists total_wins_drivers;

create or replace function total_wins_drivers(nameref text)
	returns integer as $$
	declare total integer;
	begin
		select into total count(*)
			from driver d
			join results r on r.driverid = d.driverid
			where d.driverref = nameref and r.position = 1;
		return total;
	end;
	$$ language plpgsql;

--teste
select total_wins_drivers('hamilton');
	
-----------------------------------------------

--primeiro e ultimo ano em que ha dados do piloto

drop function if exists first_last_year_drivers;

create or replace function first_last_year_drivers(nameref text)
	returns table(primeiro integer, ultimo integer) as $$
	begin
		return query
			select min(rc.year) as first_year, max(rc.year) as last_year
				from driver d
				join results r on r.driverid = d.driverid 
				join races rc on rc.raceid = r.raceid 
				where d.driverref = nameref;
	end;
	$$ language plpgsql;

--teste
select first_last_year_drivers('hamilton');