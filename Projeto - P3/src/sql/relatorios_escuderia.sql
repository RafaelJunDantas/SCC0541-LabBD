--relatorio escuderia

--relatorio 3
--lista os pilotos da escuderia, bem como a quantidade de vezes em que cada um deles
--alcancou a primeira posicao em uma corrida 

drop function if exists report3;

create or replace function report3(escuderia text)
	returns table(driver text, forename text, name_ text, wins int8) as $$
	declare id integer;
	begin	
		select into id constructorid from constructors where constructorref = escuderia;
		return query	
			select d.driverref, d.forename, d.surname, count(d.driverref) as wins
					from results r
					join driver d on d.driverid = r.driverid 
					where r.position = 1 and r.constructorid = id
					group by d.driverref,d.forename, d.surname;
	end;
	$$language plpgsql;

--teste
select report3('mclaren');

------------------------------------------

--relatorio 4
--liste a quantidade de resultados por cada status, apresentando
--o status e sua contagem, limitados ao escopo de sua escuderia

drop function if exists report4;

create or replace function report4(escuderia text)
	returns table(status text, total int8) as $$
	declare id integer;
	begin	
		select into id constructorid from constructors where constructorref = escuderia;
		return query	
			select s.status, count(s.status) as total	
				from results r 
				join status s on s.statusid = r.statusid 
				where r.constructorid = id
				group by s.status;
	end;
	$$language plpgsql;
	
--teste
select report4('mclaren');
