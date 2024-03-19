CREATE SCHEMA IF NOT EXISTS SA_CASH_RENTAL;
CREATE SCHEMA IF NOT EXISTS SA_ONLINE_RENTAL;

CREATE EXTENSION IF NOT EXISTS file_fdw;
CREATE SERVER IF NOT EXISTS bike_rental FOREIGN DATA WRAPPER file_fdw;


CREATE FOREIGN TABLE IF NOT EXISTS SA_CASH_RENTAL.ext_bike_rental (
  	ride_id varchar(100), 
	bike_type varchar(100), 
	start_station varchar(100),
	start_id varchar(100),
	end_station varchar(100),
	end_id varchar(100),
	start_lat decimal(4,2),
	start_lng decimal(4,2),
	end_lat decimal(4,2),
	end_lng decimal(4,2),
	member_status varchar(100),
	start_date date,
	start_time time,
	end_date date,
	end_time time,
	ride_time_mins int,
	season varchar(100),
	minutes_price decimal,
	charde_percent decimal,
	customer_id bigint,
	first_name varchar(100),
	last_name varchar(100),
	birth_date date,
	gender varchar (100)
) SERVER bike_rental
OPTIONS ( filename 'C:\Users\user\Hayk_Ghazakhyan_WCAAU23\DWH\Task 1\bike_rental.csv', format 'csv', header 'true' );




CREATE SERVER IF NOT EXISTS online_bike_rental FOREIGN DATA WRAPPER file_fdw;

CREATE FOREIGN TABLE  IF NOT EXISTS SA_ONLINE_RENTAL.ext_online_bike_rental (
  	online_ride_id varchar(100), 
	type varchar(100), 
	beginning_location varchar(100),
	beginning_id varchar(100),
	finish_location varchar(100),
	finish_id varchar(100),
	beginning_lat decimal(4,2),
	beginning_lng decimal(4,2),
	finish_lat decimal(4,2),
	finish_lng decimal(4,2),
	user_status varchar(100),
	beginning_date date,
	beginning_time time,
	finish_date date,
	finish_time time,
	ride_duration int,
	season varchar(100),
	minutes_price decimal,
	charde_percent decimal,
	customer_id bigint,
	first_name varchar(100),
	last_name varchar(100),
	birth_date date,
	gender varchar (100),
	bank_account varchar(100),
	bank_name varchar(100),
	payment_date date,
	payment_amount decimal(4,2)
) SERVER bike_rental
OPTIONS ( filename 'C:\Users\user\Hayk_Ghazakhyan_WCAAU23\DWH\Task 1\online_bike_rental.csv', format 'csv', header 'true' );



CREATE TABLE IF NOT EXISTS sa_cash_rental.SRC_bike_rental (
	ride_id varchar(100), 
	bike_type varchar(100), 
	start_station varchar(100),
	start_id varchar(100),
	end_station varchar(100),
	end_id varchar(100),
	start_lat decimal(4,2),
	start_lng decimal(4,2),
	end_lat decimal(4,2),
	end_lng decimal(4,2),
	member_status varchar(100),
	start_date date,
	start_time time,
	end_date date,
	end_time time,
	ride_time_mins int,
	season varchar(100),
	minutes_price decimal,
	charde_percent decimal,
	customer_id bigint,
	first_name varchar(100),
	last_name varchar(100),
	birth_date date,
	gender varchar (100)
);


CREATE TABLE IF NOT EXISTS sa_online_rental.SRC_online_bike_rental(
	online_ride_id varchar(100), 
	type varchar(100), 
	beginning_location varchar(100),
	beginning_id varchar(100),
	finish_location varchar(100),
	finish_id varchar(100),
	beginning_lat decimal(4,2),
	beginning_lng decimal(4,2),
	finish_lat decimal(4,2),
	finish_lng decimal(4,2),
	user_status varchar(100),
	beginning_date date,
	beginning_time time,
	finish_date date,
	finish_time time,
	ride_duration int,
	season varchar(100),
	minutes_price decimal,
	charde_percent decimal,
	customer_id bigint,
	first_name varchar(100),
	last_name varchar(100),
	birth_date date,
	gender varchar (100),
	bank_account varchar(100),
	bank_name varchar(100),
	payment_date date,
	payment_amount decimal(4,2)	
);


INSERT INTO sa_cash_rental.src_bike_rental
	SELECT * 
	FROM sa_cash_rental.ext_bike_rental
	WHERE NOT EXISTS 
					(SELECT 1 FROM sa_cash_rental.src_bike_rental);

				
INSERT INTO sa_online_rental.src_online_bike_rental
	SELECT * 
	FROM sa_online_rental.ext_online_bike_rental
	WHERE NOT EXISTS 
					(SELECT 1 FROM sa_online_rental.src_online_bike_rental);
				
SELECT * FROM sa_cash_rental.src_bike_rental;
SELECT * FROM sa_online_rental.src_online_bike_rental