--tabela log_tabela

drop table log_table;

create table if not exists log_table(
	logid serial not null,
	userid int not null,
	data date default current_date,
	hora time default localtime(5),
	tipo text not null,
	constraint pk_log primary key(logid),
	constraint fk_log_table foreign key(userid) references users(userid),
	constraint ck_log_table_tipo check(tipo = 'connect' or tipo = 'disconnect' or tipo = 'commit')
);

drop procedure if exists new_log cascade;

create or replace procedure new_log(userid_ int, tipo_ text)
	as $$
	begin
		insert into log_table(userid, tipo) values (userid_, tipo_);
	end;
	$$language plpgsql;

--teste
/*
call new_log(0, current_date, current_time, 'connect');
call new_log(0, current_date, current_time, 'commit');
call new_log(0, current_date, current_time, 'desconnect');

select * from log_table;
*/