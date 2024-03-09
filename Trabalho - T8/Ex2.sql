--exercicio 2

drop function mede_tempo2;

create or replace function mede_tempo2(q text)
	returns table (cidade text, lat numeric(13,5), lon numeric(13,5), pop bigint) as 
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

drop function info_cidade(nome text);

create or replace function info_cidade(nome text)
	returns table(cidade text, lat numeric(13,5), lon numeric(13,5), pop bigint) as
	$$
	begin
		return query
			select gc.name, gc.lat, gc.long, gc.population 
				from geocities15k gc
				where gc.country = 'BR' and gc.name like (nome || '%');
	end
	$$language plpgsql;

select * from mede_tempo2('select * from info_cidade(''Rio'')');


drop index idx_geocities15k_coord_pop;

create index idx_geocities15k_coord_pop
	on geocities15k(name)
	include (lat, long, population)
	where country = 'BR';