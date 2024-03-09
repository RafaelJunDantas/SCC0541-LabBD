--exercicio 4

select distinct(c.nationality), 
	array_agg(c.name) over(partition by c.nationality)
	from constructors c
	order by c.nationality;