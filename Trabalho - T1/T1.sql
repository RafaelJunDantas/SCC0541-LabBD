CREATE TABLE countries(
    id integer NOT NULL,
    code varchar(2) NOT NULL,
    name varchar(255) NOT NULL,
    continent varchar(2) NOT NULL,
    wikipedia_link text NOT NULL,
    keywords text,
    CONSTRAINT pk_countries PRIMARY KEY(id),
    CONSTRAINT uk_countries UNIQUE(code)
);

CREATE TABLE cities(
    id integer NOT NULL,
    name varchar(200) NOT NULL,
    ascii_name varchar(200) NOT NULL,
    alternate_names text,
    latitude numeric(8,4) NOT NULL,
    longitude numeric(8,4) NOT NULL,
    feature_class varchar(1) NOT NULL,
    feature_code varchar(10) NOT NULL,
    country varchar(2) NOT NULL,
    cc2 varchar(200),
    admin1_code varchar(20),
    admin2_code varchar(80),
    admin3_code varchar(20),
    admin4_code varchar(20),
    population bigint NOT NULL,
    elevation integer,
    dem integer,
    time_zone varchar(40) NOT NULL,
    modification DATE NOT NULL,
    CONSTRAINT pk_cities PRIMARY KEY(id)
);

CREATE TABLE airports(
    id integer NOT NULL,
    ident varchar(20) NOT NULL,
    type varchar(255) NOT NULL,
    name varchar(255) NOT NULL,
    latitude numeric(8,4) NOT NULL,
    longitude numeric(8,4) NOT NULL,
    elevation integer,
    continent varchar(2) NOT NULL,
    iso_country varchar(2) NOT NULL,
    iso_region varchar(25) NOT NULL,
    municipality varchar(255),
    scheduled_service boolean NOT NULL,
    gps_code varchar(20),
    iata_code varchar(20),
    local_code varchar(20),
    home_link text,
    wikipedia_link text,
    keywords varchar(555),
    CONSTRAINT pk_airports PRIMARY KEY(id),
    CONSTRAINT uk_airports UNIQUE(ident)
);

CREATE TABLE circuits(
	id integer NOT NULL,
	circuit_ref varchar(255) NOT NULL,
	name varchar(255) NOT NULL,
	location varchar(255) NOT NULL,
	country varchar(255) NOT NULL,
	latitude numeric(8,4) NOT NULL,
	longitude numeric(8,4) NOT NULL,
	altitude integer,
	url text NOT NULL,
	CONSTRAINT pk_circuits PRIMARY KEY(id),
	CONSTRAINT uk_circuits UNIQUE(circuit_ref)
);

CREATE TABLE seasons(
	year integer NOT NULL,
	url text NOT NULL,
	CONSTRAINT pk_seasons PRIMARY KEY(year)
);

CREATE TABLE status(
	id integer NOT NULL,
	status varchar(255) NOT NULL,
	CONSTRAINT pk_status PRIMARY KEY(id)
);

CREATE TABLE constructors(
	id integer NOT NULL,
	constructors_ref varchar(255) NOT NULL,
	name varchar(255) NOT NULL,
	nationality varchar(255) NOT NULL,
	url text NOT NULL,
	CONSTRAINT pk_constructors PRIMARY KEY(id),
	CONSTRAINT uk_constructors UNIQUE(constructors_ref)
);

CREATE TABLE drivers(
	id integer NOT NULL,
	driver_ref varchar(255) NOT NULL,
	number smallint DEFAULT NULL,
	code varchar(3) DEFAULT NULL,
	forename varchar(255) NOT NULL,
	surname varchar(255) NOT NULL,
	date_of_birth date,
	nationality varchar(255),
	url text NOT NULL,
	CONSTRAINT pk_drivers PRIMARY KEY(id),
	CONSTRAINT uk_drivers UNIQUE(driver_ref)
);

CREATE TABLE races(
	id integer NOT NULL,
	year integer NOT NULL,
	round SMALLINT NOT NULL,
	circuit_id integer NOT NULL,
	name varchar(255) NOT NULL,
	date date NOT NULL,
	time time,
	url text,
	fp1_date varchar(10),	--colunas adicionais para dar copy
	fp1_time varchar(10),	--serao removidas depois
	fp2_date varchar(10),
	fp2_time varchar(10), 
	fp3_date varchar(10), 
	fp3_time varchar(10),
	quali_date varchar(10),
	quali_time varchar(10), 
	sprint_date varchar(10),
	sprint_time varchar(10),
	CONSTRAINT pk_races PRIMARY KEY(id),
	CONSTRAINT fk1_races FOREIGN KEY(year) REFERENCES seasons(year) ON DELETE CASCADE,
	CONSTRAINT fk2_races FOREIGN KEY(circuit_id) REFERENCES circuits(id)
);

CREATE TABLE driver_standings(
	id integer NOT NULL,
	race_id integer NOT NULL,
	driver_id integer NOT NULL,
	points numeric(8,4) NOT NULL,
	position integer DEFAULT NULL,
	position_text varchar(255),
	wins integer NOT NULL,
	CONSTRAINT pk_driver_standings PRIMARY KEY(id),
	CONSTRAINT fk1_driver_standings FOREIGN KEY(race_id) REFERENCES races(id) ON DELETE CASCADE,
	CONSTRAINT fk2_driver_standings FOREIGN KEY(driver_id) REFERENCES drivers(id) ON DELETE CASCADE
);

CREATE TABLE results(
	id integer NOT NULL,
	race_id integer NOT NULL,
	driver_id integer NOT NULL,
	constructor_id integer NOT NULL,
	number smallint,
	grid smallint NOT NULL,
	position smallint DEFAULT NULL,
	position_text varchar(4) NOT NULL,
	position_order numeric(8,4) NOT NULL,
	points numeric(8,4) NOT NULL,
	laps smallint NOT NULL,
	time varchar(15),
	milliseconds integer,
	fastest_lap smallint,
	rank smallint,
	fastest_lap_time time default '00:00:00.000',
	fastestLapSpeed numeric(6,3),
	status_id integer NOT NULL,
	CONSTRAINT pk_results PRIMARY KEY(id),
	CONSTRAINT fk1_results FOREIGN KEY(race_id) REFERENCES races(id) ON DELETE CASCADE,
	CONSTRAINT fk2_results FOREIGN KEY(driver_id) REFERENCES drivers(id) ON DELETE CASCADE,
	CONSTRAINT fk3_results FOREIGN KEY(constructor_id) REFERENCES constructors(id),
	CONSTRAINT fk4_results FOREIGN KEY(status_id) REFERENCES status(id)
);

CREATE TABLE qualifying(
	id integer NOT NULL,
	race_id integer NOT NULL,
	driver_id integer NOT NULL,
	constructor_id integer NOT NULL,
	number integer NOT NULL,
	position integer,
	q1 varchar(255),
	q2 varchar(255) default NULL,
	q3 varchar(255) default NULL,
	CONSTRAINT pk_qualifying PRIMARY KEY(id),
	CONSTRAINT fk1_qualifying FOREIGN KEY(race_id) REFERENCES races(id) ON DELETE CASCADE,
	CONSTRAINT fk2_qualifying FOREIGN KEY(driver_id) REFERENCES drivers(id) ON DELETE CASCADE,
	CONSTRAINT fk3_qualifying FOREIGN KEY(constructor_id) REFERENCES constructors(id)
);

CREATE TABLE lap_time(
	race_id integer NOT NULL,
	driver_id integer NOT NULL,
	lap smallint NOT NULL,
	position smallint NOT NULL,
	time time NOT NULL,
	milliseconds integer NOT NULL,
	CONSTRAINT pk_lap_time PRIMARY KEY(race_id, driver_id, lap),
	CONSTRAINT fk1_lap_time FOREIGN KEY(race_id) REFERENCES races(id) ON DELETE CASCADE,
	CONSTRAINT fk2_lap_time FOREIGN KEY(driver_id) REFERENCES drivers(id) ON DELETE CASCADE
);

CREATE TABLE pit_stop(
	race_id integer NOT NULL,
	driver_id integer NOT NULL,
	stop smallint NOT NULL,
	position smallint NOT NULL,
	time time NOT NULL,
	duration varchar(10),
	milliseconds integer,
	CONSTRAINT pk_pit_stop PRIMARY KEY(race_id, driver_id, stop),
	CONSTRAINT fk1_pit_stop FOREIGN KEY(race_id) REFERENCES races(id) ON DELETE CASCADE,
	CONSTRAINT fk2_pit_stop FOREIGN KEY(driver_id) REFERENCES drivers(id) ON DELETE CASCADE
);