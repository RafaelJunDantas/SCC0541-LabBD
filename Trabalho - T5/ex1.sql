create or replace function Nome_Nacionalidade(nome text)
	returns text as $$
	declare 
		nacionalidade text;
	begin 
		select into nacionalidade c.nationality
			from constructors c
			where c.name = nome;
		return nacionalidade;
	end;
$$ language plpgsql;