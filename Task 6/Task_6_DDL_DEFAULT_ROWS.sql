CREATE SCHEMA IF NOT EXISTS BL_3NF;


CREATE SEQUENCE IF NOT EXISTS location_id_seq START 1;

CREATE TABLE IF NOT EXISTS BL_3NF.CE_Locations(
	location_id int PRIMARY KEY NOT NULL DEFAULT nextval('location_id_seq'),
	location_coordinate_SRC_id varchar(256) NOT NULL  DEFAULT 'n.a.',
	location_beginning_street varchar(256) NOT NULL DEFAULT 'n.a.',
	location_start_latitude varchar(256) NOT NULL DEFAULT 'n.a.',
	location_start_longitude varchar(256) NOT NULL DEFAULT 'n.a.',
	location_finish_street varchar(256) NOT NULL DEFAULT 'n.a.',
	location_finish_latitude varchar(256) NOT NULL DEFAULT 'n.a.',
	location_finish_longitude varchar(256) NOT NULL DEFAULT 'n.a.',
	insert_date date NOT NULL DEFAULT '1900-01-01',
	update_dt date NOT NULL DEFAULT '1900-01-01',
	source_system varchar(256) NOT NULL DEFAULT 'MANUAL',
	source_table varchar(256) NOT NULL DEFAULT 'MANUAL'
);



CREATE SEQUENCE IF NOT EXISTS cycle_id_seq START 1;

CREATE TABLE IF NOT EXISTS BL_3NF.CE_Cycles_SCD(
	cycle_id int PRIMARY KEY NOT NULL DEFAULT nextval('cycle_id_seq'),
	type_brand_SRC_id varchar(256) NOT NULL DEFAULT 'n.a.',
	cycle_type varchar(256) NOT NULL DEFAULT 'n.a.',
	cycle_brand varchar(256) NOT NULL DEFAULT 'n.a.',
	cycle_minutes_price int NOT NULL DEFAULT -1,
	start_dt date NOT NULL DEFAULT '1900-01-01',
	end_dt date NOT NULL DEFAULT '9999-01-01',
	is_active varchar(256) NOT NULL DEFAULT 'Y',
	insert_date date NOT NULL DEFAULT '1900-01-01',
	source_system varchar(256) NOT NULL DEFAULT 'MANUAL',
	source_table varchar(256) NOT NULL DEFAULT 'MANUAL'
);


CREATE SEQUENCE IF NOT EXISTS bank_id_seq START 1;

CREATE TABLE IF NOT EXISTS BL_3NF.CE_Banks(
	bank_id int PRIMARY KEY NOT NULL DEFAULT nextval('bank_id_seq'),
	bank_account_SRC_ID VARCHAR(256) NOT NULL DEFAULT 'n.a.',
	bank_name varchar(256) NOT NULL DEFAULT 'n.a.',
	bank_account varchar(256) NOT NULL DEFAULT 'n.a.',
	insert_date date NOT NULL DEFAULT '1900-01-01',
	update_dt date NOT NULL DEFAULT '1900-01-01',
	source_system varchar(256) NOT NULL DEFAULT 'MANUAL',
	source_table varchar(256) NOT NULL DEFAULT 'MANUAL'	
);



CREATE SEQUENCE IF NOT EXISTS customer_id_seq START 1;

CREATE TABLE IF NOT EXISTS BL_3NF.CE_Customers(
	customer_id int PRIMARY KEY NOT NULL DEFAULT nextval('customer_id_seq'),
	customer_email_SRC_ID varchar(256) NOT NULL DEFAULT 'n.a.',
	customer_first_name varchar(256) NOT NULL DEFAULT 'n.a.',
	customer_last_name varchar(256) NOT NULL DEFAULT 'n.a.',
	customer_email varchar(256) NOT NULL DEFAULT 'n.a.',
	customer_birth_dt date NOT NULL DEFAULT '1900-01-01',
	customer_gender varchar(256) NOT NULL DEFAULT 'n.a',
	customer_status varchar(256) NOT NULL DEFAULT 'n.a',
	insert_date date NOT NULL DEFAULT '1900-01-01',
	update_dt date NOT NULL DEFAULT '1900-01-01',
	source_system varchar(256) NOT NULL DEFAULT 'MANUAL',
	source_table varchar(256) NOT NULL DEFAULT 'MANUAL'	

);


CREATE SEQUENCE IF NOT EXISTS bank_customer_id_seq START 1;

CREATE TABLE IF NOT EXISTS BL_3NF.CE_Banks_Customers(
	bank_customer_id int PRIMARY KEY NOT NULL DEFAULT nextval('bank_customer_id_seq'),
	customer_id bigint REFERENCES BL_3NF.CE_Customers(customer_id) NOT NULL DEFAULT -1,
	bank_id bigint REFERENCES BL_3NF.CE_Banks(Bank_id) NOT NULL DEFAULT -1
);



CREATE SEQUENCE IF NOT EXISTS rental_id_seq START 1;

CREATE TABLE IF NOT EXISTS BL_3NF.CE_Rentals(
	rental_id int PRIMARY KEY NOT NULL DEFAULT nextval('rental_id_seq'),
	ride_SRC_id varchar(256) NOT NULL DEFAULT 'n.a.',
	rental_event_dt date NOT NULL DEFAULT '1900-01-01',
	rental_tm time NOT NULL DEFAULT '24:00:00',
	rental_end_dt date NOT NULL DEFAULT '9999-01-01',
	rental_end_tm time NOT NULL DEFAULT '24:00:00',
	rental_season varchar(256) NOT NULL DEFAULT 'n.a.',
	rental_location_id bigint NOT NULL REFERENCES BL_3NF.CE_Locations(location_id) DEFAULT -1,
	rental_customer_id bigint NOT NULL REFERENCES BL_3NF.CE_Customers(customer_id) DEFAULT -1,
	rental_cycle_id bigint NOT NULL DEFAULT -1, --NOR REFERENCE TO SCD type2 
	rental_duration int NOT NULL DEFAULT -1,
	source_system varchar(256) NOT NULL DEFAULT 'MANUAL',
	source_table varchar(256) NOT NULL DEFAULT 'MANUAL'
);


CREATE SEQUENCE IF NOT EXISTS payment_id_seq START 1;

CREATE TABLE IF NOT EXISTS BL_3NF.CE_Payments(
	payment_id int PRIMARY KEY NOT NULL DEFAULT nextval('payment_id_seq'),
	customer_payment_dt_SRC_id varchar(256) NOT NULL DEFAULT 'n.a.',
	payment_rental_id bigint NOT NULL REFERENCES BL_3NF.CE_Rentals(rental_id) DEFAULT -1,
	payment_customer_id bigint NOT NULL REFERENCES BL_3NF.CE_Customers(customer_id) DEFAULT -1,
	payment_discount_percent decimal NOT NULL DEFAULT -1,
	payment_amount int NOT NULL DEFAULT -1,
	payment_dt date NOT NULL DEFAULT '1900-01-01',
	insert_date date NOT NULL DEFAULT '1900-01-01',
	update_dt date NOT NULL DEFAULT '1900-01-01',
	source_system varchar(256) NOT NULL DEFAULT 'MANUAL',
	source_table varchar(256) NOT NULL DEFAULT 'MANUAL'	
);




INSERT INTO bl_3nf.CE_Locations(location_id, location_coordinate_SRC_id, location_beginning_street, location_start_latitude, location_start_longitude,
	location_finish_street, location_finish_latitude, location_finish_longitude, insert_date, update_dt, source_system, source_table)
SELECT -1, 'n.a.', 'n.a.', 'n.a.', 'n.a.', 'n.a.', 'n.a.', 'n.a.', '1900-01-01', '1900-01-01', 'MANUAL', 'MANUAL'
WHERE NOT EXISTS (SELECT * FROM bl_3nf.CE_Locations);


INSERT INTO bl_3nf.ce_cycles_scd (cycle_id, type_brand_src_id, cycle_type, cycle_brand, cycle_minutes_price,
									start_dt, end_dt, is_active, insert_date, source_system, source_table)
SELECT -1, 'n.a.', 'n.a.', 'n.a.', -1, '1900-01-01', '9999-01-01', 'Y', '1900-01-01', 'MANUAL', 'MANUAL'
WHERE NOT EXISTS (SELECT * FROM bl_3nf.ce_cycles_scd);

	
INSERT INTO BL_3NF.ce_banks (bank_id, bank_account_src_id, bank_name, bank_account, insert_date, update_dt, source_system, source_table)
SELECT -1, 'n.a.', 'n.a.', 'n.a.', '1900-01-01', '1900-01-01', 'MANUAL', 'MANUAL'
WHERE NOT EXISTS (SELECT * FROM BL_3NF.ce_banks);

INSERT INTO bl_3nf.ce_customers (customer_id, customer_email_src_id, customer_first_name, customer_last_name,
								customer_email, customer_birth_dt, customer_gender, customer_status, insert_date, update_dt, source_system, source_table)
SELECT -1, 'n.a.', 'n.a.', 'n.a.', 'n.a.', '1900-01-01', 'n.a.', 'n.a.', '1900-01-01', '1900-01-01', 'MANUAL', 'MANUAL'
WHERE NOT EXISTS (SELECT * FROM bl_3nf.ce_customers);		

INSERT INTO bl_3nf.ce_banks_customers (bank_customer_id, customer_id, bank_id)
SELECT -1, -1, -1
WHERE NOT EXISTS (SELECT * FROM bl_3nf.ce_banks_customers);

--INSERT INTO bl_3nf.CE_Rentals (rental_id, ride_SRC_id, rental_event_dt, rental_tm, rental_end_dt, rental_end_tm, rental_season, rental_location_id,
--			rental_customer_id, rental_cycle_id, rental_duration, source_system, source_table)
--SELECT -1, 'n.a.', '1900-01-01', '00:00:00', '9999-01-01', '24:00:00', 'n.a.', -1, -1, -1, -1, 'MANUAL', 'MANUAL'
--WHERE NOT EXISTS (SELECT * FROM bl_3nf.ce_rentals);



INSERT INTO bl_3nf.ce_payments(payment_id, customer_payment_dt_src_id, payment_rental_id, payment_customer_id, payment_discount_percent,
							payment_amount, payment_dt, insert_date, update_dt, source_system, source_table)
SELECT -1, 'n.a', -1, -1, -1, -1, '1900-01-01', '1900-01-01', '1900-01-01', 'MANUAL', 'MANUAL'
WHERE NOT EXISTS (SELECT * FROM bl_3nf.ce_payments);

COMMIT;
