--exercicio 2

--1.
select distinct(c.name), c.nationality, 
	count(*) over(partition by c.name) as constructor_wins
	from results r 
	join constructors c on c.constructorid = r.constructorid and r.position = 1
	order by constructor_wins desc;

--confirmar os resultados
/*
select c.name, count(*) as wins
	from results r 
	join constructors c on c.constructorid = r.constructorid and r.position = 1 and c.name = 'Alta'
	group by c.name 
	order by wins desc;
*/

--2.
select distinct(c.name), c.nationality, 
	count(*) over(partition by c.name) as constructor_wins,
	count(*) over(partition by c.nationality) as nationality_wins
	from results r 
	join constructors c on c.constructorid = r.constructorid and r.position = 1
	order by constructor_wins desc;

--confirmar os resultados
/*
select c.nationality, count(*) as wins
	from results r 
	join constructors c on c.constructorid = r.constructorid and r.position = 1 and c.nationality = 'British'
	group by c.nationality 
	order by wins desc;
*/

--3.
select *, dense_rank() over(partition by k.nationality order by k.constructor_wins DESC, k.name) as national_ranking
	from(
    select distinct(c.name), c.nationality,
   	 count(*) over(partition by c.name) as constructor_wins,
   	 count(*) over(partition by c.nationality) as nationality_wins
   	 from results r
   	 join constructors c on c.constructorid = r.constructorid and r.position = 1
   	 order by nationality_wins desc) k
order by k.nationality, national_ranking