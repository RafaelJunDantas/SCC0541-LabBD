create or replace function Numero_vitorias(nome text, sobrenome text, ano integer default null)
	returns integer as $$
		declare total_vitorias integer;
		declare nome_completo text := nome || ' ' || sobrenome;
	begin
		case
			when ano is null then
				select into total_vitorias count(*)
					from driver d
					join results r on r.driverid = d.driverid and r.position = 1
					where d.forename = nome and d.surname = sobrenome;
			when ano is not null then
				select into total_vitorias count(*)
					from driver d
					join results r on r.driverid = d.driverid and r.position = 1
					join races rc on rc.raceid = r.raceid and rc.year = ano
					where d.forename = nome and d.surname = sobrenome;
		end case;
		raise notice '% %', total_vitorias, nome_completo;
		return total_vitorias;
	end	
	$$ language plpgsql;