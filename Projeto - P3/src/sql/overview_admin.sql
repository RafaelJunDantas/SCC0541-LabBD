--overview admin

-----------------------------------------------

--quantidade de drivers total

drop function if exists total_drivers;

create or replace function total_drivers()
	returns integer as $$
	declare total integer;
	begin
		select into total count(*) from driver;
		return total;
	end;
	$$ language plpgsql;

--teste
select total_drivers();

-----------------------------------------------

--quantidade de constructors total

drop function if exists total_constructors;

create or replace function total_constructors()
	returns integer as $$
	declare total integer;
	begin
		select into total count(*) from constructors;
		return total;
	end;
	$$ language plpgsql;

--teste
select total_constructors();

-----------------------------------------------

--quantidade de corridas total

drop function if exists total_races;

create or replace function total_races()
	returns integer as $$
	declare total integer;
	begin
		select into total count(*) from races;
		return total;
	end;
	$$ language plpgsql;

--teste
select total_races();

-----------------------------------------------

--quantidade de temporadas total

drop function if exists total_seasons;

create or replace function total_seasons()
	returns integer as $$
	declare total integer;
	begin
		select into total count(*) from seasons;
		return total;
	end;
	$$ language plpgsql;

--teste
select total_seasons();