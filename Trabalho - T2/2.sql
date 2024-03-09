--2
select year, count(*) as races
	from races
	group by year
	order by races desc;
