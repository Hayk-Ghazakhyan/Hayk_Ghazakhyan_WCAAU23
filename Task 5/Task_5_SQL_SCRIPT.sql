CREATE SCHEMA IF NOT EXISTS SA_CASH_RENTAL;
CREATE SCHEMA IF NOT EXISTS SA_ONLINE_RENTAL;



CREATE EXTENSION IF NOT EXISTS file_fdw;
CREATE SERVER IF NOT EXISTS bike_rental FOREIGN DATA WRAPPER file_fdw;


CREATE FOREIGN TABLE IF NOT EXISTS SA_CASH_RENTAL.ext_bike_rental (
  	ride_id varchar(1000), 
	bike_type varchar(1000),
	cycle_brand varchar(1000),
	start_station varchar(1000),
	start_id varchar(1000),
	end_station varchar(1000),
	end_id varchar(1000),
	start_lat varchar(1000),
	start_lng varchar(1000),
	end_lat varchar(1000),
	end_lng varchar(1000),
	member_status varchar(1000),
	start_date varchar(1000),
	start_time varchar(1000),
	end_date varchar(1000),
	end_time varchar(1000),
	ride_time_mins varchar(1000),
	season varchar(1000),
	minutes_price varchar(1000),
	charde_percent varchar(1000),
	customer_id varchar(1000),
	first_name varchar(1000),
	last_name varchar(1000),
	email varchar(1000),
	birth_date varchar(1000),
	gender varchar(1000)
) SERVER bike_rental
OPTIONS ( filename 'C:\Users\user\Hayk_Ghazakhyan_WCAAU23\DWH\Task 1\bike_rental.csv', format 'csv', header 'true' );




CREATE SERVER IF NOT EXISTS online_bike_rental FOREIGN DATA WRAPPER file_fdw;

CREATE FOREIGN TABLE  IF NOT EXISTS SA_ONLINE_RENTAL.ext_online_bike_rental (
  	online_ride_id varchar(1000), 
	type varchar(1000), 
	cycle_brand varchar(1000),
	beginning_location varchar(1000),
	beginning_id varchar(1000),
	finish_location varchar(1000),
	finish_id varchar(1000),
	beginning_lat varchar(1000),
	beginning_lng varchar(1000),
	finish_lat varchar(1000),
	finish_lng varchar(1000),
	user_status varchar(1000),
	beginning_date varchar(1000),
	beginning_time varchar(1000),
	finish_date varchar(1000),
	finish_time varchar(1000),
	ride_duration varchar(1000),
	season varchar(1000),
	minutes_price varchar(1000),
	charde_percent varchar(1000),
	customer_id varchar(1000),
	first_name varchar(1000),
	last_name varchar(1000),
	email varchar(1000),
	birth_date varchar(1000),
	gender varchar (1000),
	bank_account varchar(1000),
	bank_name varchar(1000),
	payment_date varchar(1000),
	payment_amount varchar(1000)
) SERVER bike_rental
OPTIONS ( filename 'C:\Users\user\Hayk_Ghazakhyan_WCAAU23\DWH\Task 1\online_bike_rental.csv', format 'csv', header 'true' );



CREATE TABLE IF NOT EXISTS sa_cash_rental.SRC_bike_rental (
	ride_id varchar(1000), 
	bike_type varchar(1000), 
	cycle_brand varchar(1000),
	start_station varchar(1000),
	start_id varchar(1000),
	end_station varchar(1000),
	end_id varchar(1000),
	start_lat varchar(1000),
	start_lng varchar(1000),
	end_lat varchar(1000),
	end_lng varchar(1000),
	member_status varchar(1000),
	start_date varchar(1000),
	start_time varchar(1000),
	end_date varchar(1000),
	end_time varchar(1000),
	ride_time_mins varchar(1000),
	season varchar(1000),
	minutes_price varchar(1000),
	charde_percent varchar(1000),
	customer_id varchar(1000),
	first_name varchar(1000),
	last_name varchar(1000),
	email varchar(1000),
	birth_date varchar(1000),
	gender varchar (1000)
);


CREATE TABLE IF NOT EXISTS sa_online_rental.SRC_online_bike_rental(
	online_ride_id varchar(1000), 
	type varchar(1000),
	cycle_brand varchar(1000),
	beginning_location varchar(1000),
	beginning_id varchar(1000),
	finish_location varchar(1000),
	finish_id varchar(1000),
	beginning_lat varchar(1000),
	beginning_lng varchar(1000),
	finish_lat varchar(1000),
	finish_lng varchar(1000),
	user_status varchar(1000),
	beginning_date varchar(1000),
	beginning_time varchar(1000),
	finish_date varchar(1000),
	finish_time varchar(1000),
	ride_duration varchar(1000),
	season varchar(1000),
	minutes_price varchar(1000),
	charde_percent varchar(1000),
	customer_id varchar(1000),
	first_name varchar(1000),
	last_name varchar(1000),
	email varchar(1000),
	birth_date varchar(1000),
	gender varchar (1000),
	bank_account varchar(1000),
	bank_name varchar(1000),
	payment_date varchar(1000),
	payment_amount varchar(1000)
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