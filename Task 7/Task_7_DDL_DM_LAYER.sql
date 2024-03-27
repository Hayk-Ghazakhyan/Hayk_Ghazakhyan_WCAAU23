CREATE SCHEMA IF NOT EXISTS BL_DM;



CREATE TABLE IF NOT EXISTS BL_DM.DIM_Dates (
    date_SURR_id int PRIMARY KEY,
    full_date DATE,
    day_of_week VARCHAR(20),
    day_of_month INT,
    month_name VARCHAR(20),
    quarter INT,
    year INT,
    season VARCHAR(20)
);




CREATE TABLE IF NOT EXISTS BL_DM.DIM_TIMES (
    time_SURR_id int PRIMARY KEY,
    full_time TIME,
    hour INT,
    minute INT,
    second INT
);


   
CREATE SEQUENCE IF NOT EXISTS location_id_seq START 1;
 
CREATE TABLE IF NOT EXISTS BL_DM.Dim_Locations(
	location_SURR_id bigint PRIMARY KEY NOT NULL DEFAULT nextval('location_id_seq'),
	location_SRC_ID varchar(256) NOT NULL DEFAULT 'n.a',
	location_beginning_street varchar(256) NOT NULL DEFAULT 'n.a.',
	location_start_latitude varchar (256) NOT NULL DEFAULT 'n.a.',
	location_start_longitude varchar(256) NOT NULL DEFAULT 'n.a.',
	location_finish_street varchar(256) NOT NULL DEFAULT 'n.a.',
	location_finish_latitude varchar (256) NOT NULL DEFAULT 'n.a.',
	location_finish_longitude varchar(256) NOT NULL DEFAULT 'n.a.',
	insert_dt date NOT NULL DEFAULT '1900-01-01',
	update_dt date NOT NULL DEFAULT '1900-01-01',
	source_system varchar(256) DEFAULT 'MANUAL',
	source_table varchar(256) DEFAULT 'MANUAL'
);


CREATE SEQUENCE IF NOT EXISTS cycle_id_seq START 1;

CREATE TABLE IF NOT EXISTS BL_DM.Dim_Cycle_SCD(
	cycle_SURR_id int PRIMARY KEY NOT NULL DEFAULT nextval('cycle_id_seq'),
	cycle_SRC_id varchar(256) NOT NULL DEFAULT 'n.a.',
	cycle_type varchar(256) NOT NULL DEFAULT 'n.a.',	
	cycle_brand varchar(256) NOT NULL DEFAULT 'n.a.',
	cycle_minutes_price int NOT NULL DEFAULT -1,
	start_dt date NOT NULL DEFAULT '1900-01-01',
	end_dt date NOT NULL DEFAULT '9999-01-01',
	is_active varchar(256) NOT NULL DEFAULT 'Y',
	insert_date date NOT NULL DEFAULT '1900-01-01',
	source_system varchar(256) NOT NULL DEFAULT 'MANUAL',
	source_table varchar(256) NOT NULL DEFAULT 'MANUAL');
							
								



CREATE SEQUENCE IF NOT EXISTS customer_id_seq START 1;

CREATE TABLE IF NOT EXISTS BL_DM.Dim_Customers(
	customer_SURR_id int PRIMARY KEY NOT NULL DEFAULT nextval('customer_id_seq'),
	customer_SRC_id varchar(256) NOT NULL DEFAULT 'n.a.',
	customer_first_name varchar(256) NOT NULL DEFAULT 'n.a.',
	customer_last_name varchar(256) NOT NULL DEFAULT 'n.a',
	customer_email varchar(256) NOT NULL DEFAULT 'n.a.',
	customer_birth_dt date NOT NULL DEFAULT '1900-01-01',
	customer_gender varchar(256) NOT NULL DEFAULT 'n.a.',
	customer_status varchar(256) NOT NULL DEFAULT 'n.a',
	insert_date date NOT NULL DEFAULT '1900-01-01',
	update_dt date NOT NULL DEFAULT '1900-01-01',
	source_system varchar(256) NOT NULL DEFAULT 'MANUAL',
	source_table varchar(256) NOT NULL DEFAULT 'MANUAL');

	


CREATE TABLE IF NOT EXISTS BL_3NF.CE_Rentals(
	rental_SRC_ID varchar(256)  NOT NULL DEFAULT 'n.a.',
	location_id bigint NOT NULL REFERENCES BL_DM.DIM_Locations(location_SURR_id) DEFAULT -1, 
	payment_id bigint NOT NULL REFERENCES BL_DM.DIM_Payments(payment_SURR_id) DEFAULT -1,	
	cycle_id bigint NOT NULL,
	customer_id bigint NOT NULL REFERENCES BL_DM.DIM_customers(customer_SURR_id) DEFAULT -1,
	rental_dt date NOT NULL REFERENCES BL_DM.DIM_Dates(date_SURR_id) DEFAULT '1900-01-01',
	rental_tm time NOT NULL REFERENCES BL_DM.DIM_Times(time_SURR_id) DEFAULT '00:00:00',
	rental_end_dt date NOT NULL REFERENCES BL_DM.DIM_Dates(date_SURR_id) DEFAULT '9999-01-01',
	rental_end_tm time NOT NULL REFERENCES BL_DM.DIM_Times(time_SURR_id) DEFAULT '00:00:00',
	discount_percent decimal NOT NULL DEFAULT -1,
	amount decimal NOT NULL DEFAULT -1,
	insert_dt date DEFAULT '1900-01-01',
	update_dt date DEFAULT '1900-01-01');
	


INSERT INTO bl_dm.DIM_times(time_SURR_id, full_time, hour, minute, second)
SELECT 000000, '00:00:00'::time, -1, -1, -1
WHERE NOT EXISTS (SELECT 1 FROM bl_dm.DIM_times WHERE time_SURR_id = 000000)
UNION 
SELECT 235959, '23:59:59'::time, -1, -1, -1
WHERE NOT EXISTS (SELECT 1 FROM bl_dm.DIM_times WHERE time_SURR_id = 235959);


INSERT INTO bl_dm.DIM_Dates(date_SURR_id, full_date, day_of_week, day_of_month, month_name, quarter, YEAR, season)
SELECT 19000101, '1900-01-01'::DATE, -1, -1, -1, -1, -1, 'n.a.'
WHERE NOT EXISTS (SELECT 1 FROM bl_dm.DIM_Dates WHERE date_SURR_id = 19000101)
UNION 
SELECT 99990101, '9999-01-01'::DATE, -1, -1, -1, -1, -1, 'n.a.'
WHERE NOT EXISTS (SELECT 1 FROM bl_dm.DIM_Dates WHERE date_SURR_id = 99990101);


INSERT INTO bl_dm.DIM_Locations(location_SURR_id, location_SRC_id, location_beginning_street, location_start_latitude, location_start_longitude,
	location_finish_street, location_finish_latitude, location_finish_longitude, insert_dt, update_dt, source_system, source_table)
SELECT -1, 'n.a.', 'n.a.', 'n.a.', 'n.a.', 'n.a.', 'n.a.', 'n.a.', '1900-01-01', '1900-01-01', 'MANUAL', 'MANUAL'
WHERE NOT EXISTS (SELECT * FROM bl_dm.dim_Locations);


INSERT INTO bl_dm.dim_cycle_scd (cycle_surr_id, cycle_src_id, cycle_type, cycle_brand, cycle_minutes_price,
								start_dt, end_dt, is_active, insert_date, source_system, source_table)
SELECT -1, 'n.a.', 'n.a.', 'n.a.', -1, '1900-01-01', '9999-01-01', 'Y', '1900-01-01', 'MANUAL', 'MANUAL'
WHERE NOT EXISTS (SELECT * FROM bl_dm.dim_cycle_scd);	


INSERT INTO bl_dm.dim_customers (customer_SURR_id, customer_SRC_id, customer_first_name, customer_last_name,
								customer_email, customer_birth_dt, customer_gender, customer_status, insert_date, update_dt, source_system, source_table)
SELECT -1, 'n.a.', 'n.a.', 'n.a.', 'n.a.', '1900-01-01', 'n.a.', 'n.a.', '1900-01-01', '1900-01-01', 'MANUAL', 'MANUAL'
WHERE NOT EXISTS (SELECT * FROM bl_dm.dim_customers);



COMMIT;