create or replace function Pilotos_Nacionalidade(nacionalidade text)
	returns void as $$
	    declare piloto driver%rowtype;
	    declare contador int;
	begin
	    contador := 1;
		for piloto in
	   	 select *
	   		 from driver d
	   		 where d.nationality = nacionalidade
	   	 loop
	   	 raise notice '% : % %', contador, piloto.forename, piloto.surname;
	   	 contador := contador + 1;
	    end loop;
	end;
	$$ language plpgsql;