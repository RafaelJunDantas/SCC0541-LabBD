create or replace procedure Cidade_Chamada(cidade text) 
	language plpgsql 
	as $$
	declare contagem integer;
	declare nome_cidade geocities15k.name%Type := cidade;
	declare populacao geocities15k.population%Type;
	declare pais countries.name%Type;
	begin
		select into contagem count(*) over(partition by gc.name)
			from geocities15k gc 
			where gc.name = cidade;
		raise notice 'Contagem: % |', contagem;
	
		for populacao, pais in 
			select gc.population, c.name
				from geocities15k gc
				join countries c on c.code = gc.country and gc.name = cidade
		loop
			raise notice 'Nome: %, População: %, País: %', nome_cidade, populacao, pais;
		end loop;
	end; $$