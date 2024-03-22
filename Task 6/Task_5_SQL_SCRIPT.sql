CREATE SCHEMA IF NOT EXISTS BL_3NF;



CREATE TABLE IF NOT EXISTS CE_Locations(
	location_id serial4 PRIMARY KEY,
	location_coordinate_SRC_id varchar(256) DEFAULT 'n.a.',
	location_beginning_street varchar(256) DEFAULT 'n.a.',
	location_start_latitude varchar(256) DEFAULT 'n.a.',
	location_start_longitude varchar(256) DEFAULT 'n.a.',
	location_finish_street varchar(256) DEFAULT 'n.a.',
	location_finish_latitude varchar(256) DEFAULT 'n.a.',
	location_finish_longitude varchar(256) DEFAULT 'n.a.',
	insert_date date DEFAULT '1900-01-01',
	update_dt date DEFAULT '1900-01-01',
	source_system varchar(256) DEFAULT 'MANUAL',
	source_table varchar(256) DEFAULT 'MANUAL'
)


CREATE TABLE IF NOT EXISTS CE_Cycles_SCD(
	cycle_id serial4 PRIMARY KEY,
	type_brand_SRC_id varchar(256) DEFAULT 'n.a.',
	cycle_type varchar(256) DEFAULT 'n.a.',
	cycle_brand varchar(256) DEFAULT 'n.a.',
	cycle_minutes_price int DEFAULT -1,
	start_dt date DEFAULT '1900-01-01',
	end_dt date '9999-01-01',
	is_active varchar(256) DEFAULT 'Y',
	insert_date date DEFAULT '1900-01-01',
	source_system varchar(256) DEFAULT 'MANUAL',
	source_table varchar(256) DEFAULT 'MANUAL'
)


CREATE TABLE IF NOT EXISTS DE_Payments(

)

CREATE TABLE IF NOT EXISTS CE_Rentals(
	rental_id serial4 PRIMARY KEY,
	ride_SRC_id varchar(256) DEFAULT 'n.a.',
	rental_event_dt date DEFAULT '1900-01-01',
	rental_tm time DEFAULT '24:00:00',
	rental_end_dt date DEFAULT '9999-01-01',
	rental_end_tm time DEFAULT '24:00:00',
	rental_season varchar(256) DEFAULT 'n.a.',
	rental_location_id bigint REFERENCES BL_3NF.CE_Locations(location_id) DEFAULT -1,
	rental_customer_id bigint REFERENCES BL_3NF.CE_Customers(customer_id) DEFAULT -1,
	rental_cycle_id bigint DEFAULT -1,
	rental_duration int DEFAULT -1,
	source_system varchar(256) DEFAULT 'MANUAL',
	source_table varchar(256) DEFAULT 'MANUAL'
)


SELECT current_time;