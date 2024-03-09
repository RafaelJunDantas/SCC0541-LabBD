--exercicio 1

create or replace trigger TR_airports
	before insert or update on airports
	for each row 
	execute function VerificaAeroporto();

create or replace function VerificaAeroporto()
	returns trigger as $$
	declare cidade geocities15k.name%type;
	begin 
		for cidade in 
			select gc.name from geocities15k gc
			loop
				if new.city = cidade then
					raise notice 'Cidade encontrada! Operação concluída.';
					return new;
				end if;
			end loop;
		raise notice 'Cidade não encontrada! Operação cancelada.';
		return null;
	end;
	$$ language plpgsql;



delete from airports a
	where a.ident = 'teste';

insert into airports (ident, name, city) values
	('teste', 'teste_aeroporto', 'teste_cidade');
--retorna 'Cidade não encontrada! Operação cancelada.'
--e a operacao e cancelada, pois nao existe
--cidade chama teste_cidade
--na tabela geocities15k

insert into airports (ident, name, city) values
	('teste', 'teste_aeroporto', 'Bensalem');
--operacao e sucedida, pois existe uma cidade 
--chamada Bensalem

update airports 
	set city = 'teste'
	where ident = '00A';
--retorna 'Cidade não encontrada! Operação cancelada.'
--e a operacao e cancelada, pois nao existe
--cidade chamada teste 
--na tabela geocitites15k

select a.ident, a.name, a.city
	from airports a 
	where a.ident = 'teste' or a.ident = '00A';