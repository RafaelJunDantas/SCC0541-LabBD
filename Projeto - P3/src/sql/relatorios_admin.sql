--relatorios

--relatorio 1
--indica a quantidade de resultados de cada status, apresentando o nome do status e sua contagem

drop function if exists report1;

create or replace function report1()
	returns table(status text, total bigint) as $$
	begin 
		return query
			select s.status, count(s.status) as total
				from status s 
				join results r on r.statusid = s.statusid
				group by s.status
				order by total desc;
	end;
	$$language plpgsql;

--teste
select report1();

--------------------------------------------

--relatorio 2
--receber o nome de uma cidade e, para cada cidade que tenha esse nome, apresenta todos os aeroportos brasileiros
--que estejam a, no maximo, 100km das respectivas cidades e que sejam dos tipos 'medium airport' ou 'large airport'

--extensoes para calcular a distancia entre coordenadas geograficas
--(latitude, longitude)
CREATE EXTENSION IF NOT EXISTS Cube; 
CREATE EXTENSION IF NOT EXISTS EarthDistance;

drop function if exists report2;

create or replace function report2(nome_cidade text)
	returns table(cidade text, iatacode bpchar(3), aeroporto text, cidade_aeroporto text, dist float8, tipo bpchar(15)) as $$
	begin
		return query
			select gk.name, a.iatacode, a.name, a.city as airport_city, 
					earth_distance(ll_to_earth(a.latdeg, a.longdeg), ll_to_earth(gk.lat, gk.long)) as dist, a.type
				from airports a, geocities15k gk 
				where gk.name like '%' || nome_cidade || '%' and gk.country = 'BR' and (a.type = 'medium_airport' or a.type = 'large_airport')
					and (earth_distance(ll_to_earth(a.latdeg, a.longdeg), ll_to_earth(gk.lat, gk.long)) <= 100000);
	end;
	$$language plpgsql;

drop index if exists idx_aeroporto_brasileiro;

create index idx_aeroporto_brasileiro
	on airports(iatacode)
	include (name, type)
	where isocountry = 'BR' and (type = 'medium_airport' or type = 'large_airport');

--teste
select report2('Rio');


