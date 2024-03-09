--4
alter table qualifying add column pole_position varchar(10);

update qualifying 
	set pole_position = 'podium' 
	where position <= 3;

select q.raceid , q.driverid, q.pole_position, q.position
	from qualifying q
	order by q.driverid, q.raceid;