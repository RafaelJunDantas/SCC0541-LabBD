--5
update driver  
	set nationality = 'BR' 
	where nationality = 'Brazilian';

select d.driverid, d.forename, d.surname, d.nationality
	from driver d 
	where d.nationality = upper('br')
	order by d.forename;