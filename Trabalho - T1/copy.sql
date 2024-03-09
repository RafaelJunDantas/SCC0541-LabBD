/* 
E:\dados\   substituir path
*/

COPY airports
FROM 'E:\dados\airports.csv'
WITH (DELIMITER ',', HEADER true, FORMAT CSV);

COPY circuits
FROM 'E:\dados\circuits.csv'
WITH (DELIMITER ',', NULL '\N', HEADER true, FORMAT CSV);

COPY seasons
FROM 'E:\dados\seasons.csv'
WITH (DELIMITER ',', NULL '\N', HEADER true, FORMAT CSV);

COPY races
FROM 'E:\dados\races.csv'
WITH (DELIMITER ',', NULL '\N', HEADER true, FORMAT CSV);

COPY cities
FROM 'E:\dados\Cities15000.tsv'
WITH (DELIMITER E'\t', HEADER false, FORMAT CSV);

COPY constructors
FROM 'E:\dados\constructors.csv'
WITH (DELIMITER ',', NULL '\N', HEADER true, FORMAT CSV);

COPY countries
FROM 'E:\dados\countries.csv'
WITH (DELIMITER ',', NULL '\N', HEADER true, FORMAT CSV);

COPY drivers
FROM 'E:\dados\drivers.csv'
WITH (DELIMITER ',', NULL '\N', HEADER true, FORMAT CSV);

COPY driver_standings
FROM 'E:\dados\driver_standings.csv'
WITH (DELIMITER ',', NULL '\N', HEADER true, FORMAT CSV);

COPY lap_time
FROM 'E:\dados\lap_times.csv'
WITH (DELIMITER ',', NULL '\N', HEADER true, FORMAT CSV);

COPY pit_stop
FROM 'E:\dados\pit_stops.csv'
WITH (DELIMITER ',', NULL '\N', HEADER true, FORMAT CSV);

COPY qualifying
FROM 'E:\dados\qualifying.csv'
WITH (DELIMITER ',', NULL '\N', HEADER true, FORMAT CSV);

COPY status
FROM 'E:\dados\status.csv'
WITH (DELIMITER ',', NULL '\N', HEADER true, FORMAT CSV);

COPY results
FROM 'E:\dados\results.csv'
WITH (DELIMITER ',', NULL '\N', HEADER true, FORMAT CSV);

alter table races drop column fp1_date;
alter table races drop column fp1_time;
alter table races drop column fp2_date;
alter table races drop column fp2_time;
alter table races drop column fp3_date;
alter table races drop column fp3_time;
alter table races drop column quali_date;
alter table races drop column quali_time;
alter table races drop column sprint_date;
alter table races drop column sprint_time;