--exercicio 2

--a, b, c
CREATE TABLE Results_Status( 
	StatusID INTEGER PRIMARY KEY, 
	Contagem INTEGER, 
	FOREIGN KEY (StatusID) REFERENCES Status(StatusID) 
); 
INSERT INTO Results_Status 
	SELECT S.StatusId , COUNT (*) 
		FROM Status S 
		JOIN Results R ON R.StatusID = S.StatusID 
		GROUP BY S.StatusId , S.Status;

create or replace function AtualizaContagem()
    returns trigger as $$
    declare cont int;
    begin
   	 if TG_OP = 'INSERT' then
   		 update results_status
   			 set Contagem = Contagem + 1
   			 where statusId = new.StatusID;
   		select into cont rs.contagem
   			from results_status rs
   			where rs.statusid = new.statusid;	 
   		raise notice 'StatusID: %, Contagem: %', new.StatusID, cont;
   	 end if;
   	 if TG_OP = 'DELETE' then
   		 update results_status rs
   			 set Contagem = Contagem - 1
   			 where statusId = old.StatusID;
   		 
   		 select into cont rs.contagem 
   		 	from results_status rs 
   		 	where rs.statusid = old.statusid;
   		 raise notice 'StatusID: %, Contagem: %', old.StatusID, cont;
   	 end if;
   	 if TG_OP = 'UPDATE' then
   		update results_status rs
   			set Contagem = Contagem + 1
   			where statusId = new.StatusID;
   		select into cont rs.contagem
   			from results_status rs
   			where rs.statusid = new.statusid;
   		raise notice 'StatusID atual: %, Contagem: %', new.StatusID, cont;
   	
   		update results_status rs
   			set Contagem = Contagem - 1
   			where statusId = old.StatusID;
   		select into cont rs.contagem
   			from results_status rs
   			where rs.statusid = old.statusid;
   		raise notice 'StatusID anterior: %, Contagem: %', old.StatusID, cont;
   	 end if;
   	 return null;
    end;
    $$ language plpgsql;
  
create or replace trigger TR_ResultStatus
    after insert or delete or update on results
    for each row
    execute function AtualizaContagem();
   

-- Testes
-- Inicial    
select * from results_status order by statusid

-- Inserindo resultado

insert into results (resultid, statusid) values (25906, 1);
insert into results (resultid, statusid) values (259067, 1);

select * from results_status order by statusid;

-- Atualizando resultado
update results
    set statusid = 2
    where resultid = 25906;
select * from results_status order by statusid;

-- Deletando resultado
delete from results
	where resultid = 25906 or resultid = 259067;

select * from results_status order by statusid;



--d

CREATE OR REPLACE FUNCTION VerificaStatus()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.statusid < 0 THEN
	RAISE EXCEPTION 'StatusID Negativo! Operação cancelada.';
  END IF;
 
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TR_Results
BEFORE INSERT OR UPDATE ON Results
FOR EACH ROW
EXECUTE FUNCTION VerificaStatus();

--teste
insert into results (resultid, statusid) values (259060, -150);