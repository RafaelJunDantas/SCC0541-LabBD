--exercicio 1

drop function mede_tempo1;

create or replace function mede_tempo1(q text)
	returns table (nome text, nationality text) as 
	$$
	declare
		ti time;
		tf time;
		i double precision;
		dif float;
	begin
		--registra o tempo inicial
		ti := clock_timestamp();
		for i in 0..100 
		loop
			execute q;
		end loop;
		
		--registra o tempo final
		tf := clock_timestamp();
		
		--calcula a diferenca
		dif := extract(epoch from tf) - extract(epoch from ti);
		raise notice '% - % = %', tf, ti, dif;
	
		--retorna o resultado da consulta recebida
		return query execute q;
	end;
	$$language plpgsql;
	

drop function nacionalidade_do_piloto;

create or replace function nacionalidade_do_piloto(nome text, sobrenome text)
	returns table(piloto text, nacionalidade text) as 
	$$
	begin
		return query
			select d.forename || ' ' || d.surname as name, d.nationality
				from driver d
				where d.forename = nome and d.surname = sobrenome;
	end;
	$$ language plpgsql;


select * from mede_tempo1('select * from nacionalidade_do_piloto(''Sebastian'', ''Vettel'')');

drop index idx_driver_nationality;

create index idx_driver_nationality 
	on driver(forename, surname)
	include (nationality);