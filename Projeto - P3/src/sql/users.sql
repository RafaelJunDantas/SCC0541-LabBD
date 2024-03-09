--tabela users e funcao de insercao/update + triggers

--cria tabela users

drop table if exists users cascade;

create table if not exists users(
	userid smallint not null,
	login text not null,
	password text not null,
	tipo text not null,
	idoriginal smallint not null,
	constraint pk_users primary key(userid),
	constraint uk_users unique(login),
	constraint ck_users_tipo check(tipo = 'admin' or tipo = 'escuderia' or tipo = 'piloto')
);

--insere admin na tabela users
insert into users values(0, 'admin', md5('admin'), 'admin', 0);

-------------------

--funcoes e triggers para insercao e update 
--de driver e constructor 
--na tabela users

drop function if exists insert_driver cascade;
drop function if exists update_driver cascade;

create or replace function insert_driver()
	returns trigger as $$
	declare id smallint;
	begin
		select into id max(u.userid) from users u;
		raise notice 'Novo user %', new.driverref;
		if id is null then 
			id := -1;
		end if;
		insert into users values(id + 1, new.driverref || '_p', md5(new.driverref), 'piloto', new.driverid);
		return null;
	end;
	$$ language plpgsql;

create or replace function update_driver()
	returns trigger as $$
	begin
		raise notice 'Update user % -> %',old.driverref, new.driverref;
		update users
			set login = new.driverref || '_p',
				password = md5(new.driverref),
				idoriginal = new.driverid
			where login = old.driverref || '_p';
		return null;
	end;
	$$ language plpgsql;

create or replace trigger tr_insert_driver
	after insert on driver
	for each row
	execute function insert_driver();

create or replace trigger tr_update_driver
	after update on driver
	for each row
	execute function update_driver();

drop function if exists insert_constructors cascade;
drop function if exists update_constructors cascade; 

create or replace function insert_constructors()
	returns trigger as $$
	declare id smallint;
	begin
		select into id max(u.userid) from users u;
		raise notice 'Novo user %', new.constructorref;
		if id is null then 
			id := -1;
		end if;
		insert into users values(id + 1, new.constructorref || '_c', md5(new.constructorref), 'escuderia', new.constructorid);
		return null;
	end;
	$$ language plpgsql;

create or replace function update_constructors()
	returns trigger as $$
	begin
		raise notice 'Update user % -> %', old.constructorref, new.constructorref;
		update users
			set login = new.constructorref || '_c',
				password = md5(new.constructorref),
				idoriginal = new.constructorid
			where login = old.constructorref || '_c';
		return null;
	end;
	$$ language plpgsql;

create or replace trigger tr_insert_constructors
	after insert on constructors
	for each row
	execute function insert_constructors();

create or replace trigger tr_update_constructors
	after update on constructors
	for each row
	execute function update_constructors();

------------------

--funcoes para criar novo driver e constructor

drop function if exists new_driver cascade;

create or replace function new_driver(driverref_ text, number_ integer, code_ text, forename_ text, surname_ text, dob_ date, nationality_ text)
	returns void as $$
	declare id smallint;
	begin
		select into id max(driverid) from driver;
		insert into driver values(id + 1, driverref_, number_, code_, forename_, surname_, dob_, nationality_);
	end;
	$$language plpgsql;
	
drop function if exists new_constructor cascade;

create or replace function new_constructor(constructorref_ text, name_ text, nationality_ text)
	returns void as $$
	declare id smallint;
	begin
		select into id max(constructorid) from constructors;
		insert into constructors values(id + 1, constructorref_, name_, nationality_);
	end;
	$$language plpgsql;

---------------------

--funcao para adicionar os pilotos e contrutores
--ja na base na tabela de users

drop function if exists add_driver_to_users;
drop function if exists add_constructor_to_users;

create or replace function add_driver_to_users()
	returns void as $$
	declare d driver%rowtype;
	declare contador integer;
	begin
		select into contador max(userid) from users;
		for d in select * from driver
			loop
				insert into users values(contador + 1, d.driverref || '_p', md5(d.driverref), 'piloto', d.driverid);
				contador := contador + 1;
			end loop;
	end;
	$$ language plpgsql;

create or replace function add_constructor_to_users()
	returns void as $$
	declare c constructors%rowtype;
	declare contador integer;
	begin
		select into contador max(userid) from users;
		for c in select * from constructors
			loop
				insert into users values(contador + 1, c.constructorref || '_c', md5(c.constructorref), 'escuderia', c.constructorid);
				contador := contador + 1;
			end loop;
	end;
	$$ language plpgsql;

select add_driver_to_users();
select add_constructor_to_users();

----------------------

--testes
delete from users where userid > 0;
select * from users;