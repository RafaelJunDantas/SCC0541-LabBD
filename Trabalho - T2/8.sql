--8
--drop table countriesv2 cascade;
create table countriesv2 as table countries;

delete from countriesv2 c2
	where c2.code not in(
		select c.code
		from countries c join airports a on c.code = a.isocountry 
		group by c.code
		having count(a.ident) <= 10
	);

select c.code, count(a.ident) as num_airports
	from countriesv2 c join airports a on c.code = a.isocountry 
	group by c.code;