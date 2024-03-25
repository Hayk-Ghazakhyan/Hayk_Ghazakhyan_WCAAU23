--because sa_cash_rental does not have any bank info we don't have any data to insert into bank table.

INSERT INTO BL_3NF.ce_banks (bank_account_src_id, bank_name, bank_account, insert_date, update_dt, source_system, source_table)
SELECT 
		COALESCE(bank_account, 'n.a.'),
		COALESCE(bank_name, 'n.a.'), 
		COALESCE(bank_account, 'n.a.'),
		CURRENT_TIMESTAMP,
		CURRENT_TIMESTAMP,
		COALESCE('sa_online_rental', 'MANUAL'), 
		COALESCE('src_online_bike_rental', 'MANUAL')
FROM sa_online_rental.src_online_bike_rental
WHERE NOT EXISTS (
    SELECT 1 
    FROM BL_3NF.ce_banks
    WHERE bl_3nf.ce_banks.bank_account_src_id = sa_online_rental.src_online_bike_rental.bank_account);
   

-- insert online bike_rental locations

WITH deduplicated_locations AS (
	-- removing dublicates
    SELECT 
        sobr.beginning_id || sobr.finish_id AS location_coordinate_SRC_id,
        sobr.beginning_location AS location_beginning_street,
        sobr.beginning_lat AS location_start_latitude,
        sobr.beginning_lng AS location_start_longitude,
        sobr.finish_location AS location_finish_street,
        sobr.finish_lat AS location_finish_latitude,
        sobr.finish_lng AS location_finish_longitude,
        CURRENT_TIMESTAMP AS insert_date,
        CURRENT_TIMESTAMP AS update_dt,
        'sa_online_rental' AS source_system, 
        'src_online_bike_rental' AS source_table,
        ROW_NUMBER() OVER (PARTITION BY sobr.beginning_id || sobr.finish_id ORDER BY sobr.beginning_id || sobr.finish_id) AS row_num
    FROM sa_online_rental.src_online_bike_rental sobr
)
INSERT INTO BL_3NF.CE_Locations (location_coordinate_SRC_id, location_beginning_street, location_start_latitude, location_start_longitude,
			location_finish_street, location_finish_latitude, location_finish_longitude, insert_date, update_dt, source_system, source_table)
SELECT 
    COALESCE(location_coordinate_SRC_id, 'n.a.'),
    COALESCE(location_beginning_street, 'n.a.'),
    COALESCE(location_start_latitude, 'n.a.'),
    COALESCE(location_start_longitude, 'n.a.'),
    COALESCE(location_finish_street, 'n.a.'),
    COALESCE(location_finish_latitude, 'n.a.'),
    COALESCE(location_finish_longitude, 'n.a.'),
    insert_date,
    update_dt,
    COALESCE(source_system, 'MANUAL'),
    COALESCE(source_table, 'MANUAL')
FROM deduplicated_locations
WHERE row_num = 1
AND NOT EXISTS (
    SELECT 1 
    FROM BL_3NF.ce_locations 
    WHERE bl_3nf.ce_locations.location_coordinate_SRC_id = deduplicated_locations.location_coordinate_SRC_id
);

---- insert cash bike_rental locations

WITH deduplicated_locations AS ( 
    SELECT 
        sbr.start_id || sbr.end_id AS location_coordinate_SRC_id,
        sbr.start_station AS location_beginning_street,
        sbr.start_lat AS location_start_latitude,
        sbr.start_lng AS location_start_longitude,
        sbr.end_station AS location_finish_street,
        sbr.end_lat AS location_finish_latitude,
        sbr.end_lng AS location_finish_longitude,
        CURRENT_TIMESTAMP AS insert_date,
        CURRENT_TIMESTAMP AS update_dt,
        'sa_cash_rental' AS source_system, 
        'src_bike_rental' AS source_table,
        ROW_NUMBER() OVER (PARTITION BY sbr.start_id || sbr.end_id ORDER BY sbr.start_id || sbr.end_id) AS row_num
    FROM sa_cash_rental.src_bike_rental sbr
)
INSERT INTO BL_3NF.CE_Locations (location_coordinate_SRC_id, location_beginning_street, location_start_latitude, location_start_longitude,
			location_finish_street, location_finish_latitude, location_finish_longitude, insert_date, update_dt, source_system, source_table)
SELECT 
    COALESCE(location_coordinate_SRC_id, 'n.a.'),
    COALESCE(location_beginning_street, 'n.a.'),
    COALESCE(location_start_latitude, 'n.a.'),
    COALESCE(location_start_longitude, 'n.a.'),
    COALESCE(location_finish_street, 'n.a.'),
    COALESCE(location_finish_latitude, 'n.a.'),
    COALESCE(location_finish_longitude, 'n.a.'),
    insert_date,
    update_dt,
    COALESCE(source_system, 'MANUAL'),
    COALESCE(source_table, 'MANUAL')
FROM deduplicated_locations
WHERE row_num = 1
AND NOT EXISTS (
    SELECT 1 
    FROM BL_3NF.ce_locations 
    WHERE bl_3nf.ce_locations.location_coordinate_SRC_id = deduplicated_locations.location_coordinate_SRC_id
);




WITH deduplicated_cycles AS (
    SELECT
        sobr.type || sobr.cycle_brand AS type_brand_src_id,
        sobr.type AS cycle_type,
        sobr.cycle_brand AS cycle_brand,
        sobr.minutes_price::DECIMAL AS cycle_minutes_price,
        CURRENT_TIMESTAMP AS start_dt,
        CURRENT_TIMESTAMP AS end_dt,
        CURRENT_TIMESTAMP AS insert_date,
        'sa_online_rental' AS source_system,
        'src_online_bike_rental' AS source_table,
        ROW_NUMBER() OVER (PARTITION BY sobr.type || sobr.cycle_brand ORDER BY sobr.type || sobr.cycle_brand) AS row_num
    FROM sa_online_rental.src_online_bike_rental sobr
)
INSERT INTO bl_3nf.ce_cycles_scd (type_brand_src_id, cycle_type, cycle_brand, cycle_minutes_price,
                                    start_dt, end_dt, insert_date, source_system, source_table)
SELECT 
    COALESCE(type_brand_src_id, 'n.a.'),
    COALESCE(cycle_type, 'n.a.'),
    COALESCE(cycle_brand, 'n.a.'),
    COALESCE(cycle_minutes_price, -1),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    COALESCE(source_system, 'MANUAL'),
    COALESCE(source_table, 'MANUAL')
FROM deduplicated_cycles
WHERE row_num = 1
AND NOT EXISTS (
    SELECT 1
    FROM bl_3nf.ce_cycles_scd 
    WHERE type_brand_src_id = deduplicated_cycles.type_brand_src_id
);

-- insert cash_rental src tables data into CE_Cycles

WITH deduplicated_cycles AS (
    SELECT
        sbr.bike_type || sbr.cycle_brand AS type_brand_src_id,
        sbr.bike_type AS cycle_type,
        sbr.cycle_brand AS cycle_brand,
        sbr.minutes_price::DECIMAL AS cycle_minutes_price,
        CURRENT_TIMESTAMP AS start_dt,
        CURRENT_TIMESTAMP AS end_dt,
        CURRENT_TIMESTAMP AS insert_date,
        'sa_cash_rental' AS source_system,
        'src_bike_rental' AS source_table,
        ROW_NUMBER() OVER (PARTITION BY sbr.bike_type || sbr.cycle_brand ORDER BY sbr.bike_type || sbr.cycle_brand) AS row_num
    FROM sa_cash_rental.src_bike_rental sbr
)
INSERT INTO bl_3nf.ce_cycles_scd (type_brand_src_id, cycle_type, cycle_brand, cycle_minutes_price,
                                    start_dt, end_dt, insert_date, source_system, source_table)
SELECT 
    COALESCE(type_brand_src_id, 'n.a.'),
    COALESCE(cycle_type, 'n.a.'),
    COALESCE(cycle_brand, 'n.a.'),
    COALESCE(cycle_minutes_price, -1),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    COALESCE(source_system, 'MANUAL'),
    COALESCE(source_table, 'MANUAL')
FROM deduplicated_cycles
WHERE row_num = 1
AND NOT EXISTS (
    SELECT 1
    FROM bl_3nf.ce_cycles_scd 
    WHERE type_brand_src_id = deduplicated_cycles.type_brand_src_id
);


WITH deduplicated_customers AS (
    SELECT
        sobr.email AS customer_email_SRC_ID,
        sobr.first_name AS customer_first_name,
        sobr.last_name AS customer_last_name,
        sobr.email AS customer_email,
        sobr.birth_date AS customer_birth_dt,
        sobr.gender AS customer_gender,
        sobr.user_status AS customer_status,
        CURRENT_TIMESTAMP AS insert_date,
        CURRENT_TIMESTAMP AS update_dt,
        'sa_online_rental' AS source_system,
        'src_online_bike_rental' AS source_table,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY email) AS row_num
    FROM sa_online_rental.src_online_bike_rental sobr
)
INSERT INTO BL_3NF.CE_Customers (customer_email_SRC_ID, customer_first_name, customer_last_name, customer_email, customer_birth_dt,
								customer_gender, customer_status, insert_date, update_dt, source_system, source_table
)
SELECT 
    COALESCE(customer_email_SRC_ID, 'n.a.'),
    COALESCE(customer_first_name, 'n.a.'),
    COALESCE(customer_last_name, 'n.a.'),
    COALESCE(customer_email, 'n.a.'),
    COALESCE(customer_birth_dt::date, '1900-01-01'),
    COALESCE(customer_gender, 'n.a.'),
    COALESCE(customer_status, 'n.a.'),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    COALESCE(source_system, 'MANUAL'),
    COALESCE(source_table, 'MANUAL')
FROM deduplicated_customers
WHERE row_num = 1
AND NOT EXISTS (
    SELECT 1
    FROM BL_3NF.CE_Customers 
    WHERE customer_email_SRC_ID = deduplicated_customers.customer_email_SRC_ID
);




-- insert customers from sa_cash_rental schema


WITH deduplicated_customers AS (
    SELECT
        sbr.email AS customer_email_SRC_ID,
        sbr.first_name AS customer_first_name,
        sbr.last_name AS customer_last_name,
        sbr.email AS customer_email,
        sbr.birth_date AS customer_birth_dt,
        sbr.gender AS customer_gender,
        sbr.member_status AS customer_status,
        CURRENT_TIMESTAMP AS insert_date,
        CURRENT_TIMESTAMP AS update_dt,
        'sa_online_rental' AS source_system,
        'src_online_bike_rental' AS source_table,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY email) AS row_num
    FROM sa_cash_rental.src_bike_rental sbr
)
INSERT INTO BL_3NF.CE_Customers (customer_email_SRC_ID, customer_first_name, customer_last_name, customer_email, customer_birth_dt,
								customer_gender, customer_status, insert_date, update_dt, source_system, source_table
)
SELECT 
    COALESCE(customer_email_SRC_ID, 'n.a.'),
    COALESCE(customer_first_name, 'n.a.'),
    COALESCE(customer_last_name, 'n.a.'),
    COALESCE(customer_email, 'n.a.'),
    COALESCE(customer_birth_dt::date, '1900-01-01'),
    COALESCE(customer_gender, 'n.a.'),
    COALESCE(customer_status, 'n.a.'),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    COALESCE(source_system, 'MANUAL'),
    COALESCE(source_table, 'MANUAL')
FROM deduplicated_customers
WHERE row_num = 1
AND NOT EXISTS (
    SELECT 1
    FROM BL_3NF.CE_Customers 
    WHERE customer_email_SRC_ID = deduplicated_customers.customer_email_SRC_ID
);

INSERT INTO BL_3NF.CE_Banks_Customers (customer_id, bank_id)
SELECT 
		cc.customer_id, 
		cb.bank_id 
		FROM sa_online_rental.src_online_bike_rental sobr
		INNER JOIN bl_3nf.ce_customers cc
		on cc.customer_email_src_id = sobr.email
		INNER JOIN bl_3nf.ce_banks cb
		ON cb.bank_account_src_id = sobr.bank_account
WHERE NOT EXISTS (
    SELECT 1
    FROM BL_3NF.CE_Banks_Customers cbc
    WHERE cc.customer_id = cbc.customer_id
    AND cbc.bank_id = cb.bank_id);


   
   
WITH deduplicated_rentals AS (
    SELECT
        sobr.online_ride_id AS ride_SRC_id,
        sobr.beginning_date AS rental_event_dt,
        sobr.beginning_time AS rental_tm,
        sobr.finish_date AS rental_end_dt,
        sobr.finish_time AS rental_end_tm,
        sobr.season AS rental_season,
        sobr.ride_duration AS rental_duration,
        'sa_online_rental' AS source_system,
        'src_online_bike_rental' AS source_table,
        ROW_NUMBER() OVER (PARTITION BY sobr.online_ride_id ORDER BY sobr.online_ride_id) AS row_num
    FROM sa_online_rental.src_online_bike_rental sobr
)
INSERT INTO BL_3NF.CE_Rentals (
    ride_SRC_id, rental_event_dt, rental_tm, rental_end_dt, rental_end_tm, rental_season,
							rental_location_id, rental_customer_id, rental_cycle_id, rental_duration, source_system, source_table)
SELECT 
    COALESCE(dr.ride_SRC_id, 'n.a.'),
    COALESCE(dr.rental_event_dt::date, '1900-01-01'),
    COALESCE(dr.rental_tm::time, '24:00:00'),
    COALESCE(dr.rental_end_dt::date, '9999-01-01'),
    COALESCE(dr.rental_end_tm::time, '24:00:00'),
    COALESCE(dr.rental_season, 'n.a.'),
    COALESCE(cl.location_id, -1), -- Assuming location_id is fetched from bl_3nf.ce_locations
    COALESCE(cc.customer_id, -1), -- Assuming customer_id is fetched from bl_3nf.ce_customers
    COALESCE(ccs.cycle_id, -1), -- Assuming cycle_id is fetched from bl_3nf.ce_cycles_scd
    COALESCE(dr.rental_duration::int, -1),
    COALESCE(dr.source_system, 'MANUAL'),
    COALESCE(dr.source_table, 'MANUAL')
FROM deduplicated_rentals dr
LEFT JOIN bl_3nf.ce_customers cc
    ON cc.customer_email_src_id = (SELECT sobr.email FROM sa_online_rental.src_online_bike_rental sobr WHERE sobr.online_ride_id = dr.ride_SRC_id)
LEFT JOIN bl_3nf.ce_locations cl
    ON cl.location_coordinate_src_id = (SELECT sobr.beginning_id || sobr.finish_id FROM sa_online_rental.src_online_bike_rental sobr WHERE sobr.online_ride_id = dr.ride_SRC_id)
LEFT JOIN bl_3nf.ce_cycles_scd ccs 
    ON ccs.type_brand_src_id = (SELECT sobr.type || sobr.cycle_brand FROM sa_online_rental.src_online_bike_rental sobr WHERE sobr.online_ride_id = dr.ride_SRC_id)
WHERE dr.row_num = 1
AND NOT EXISTS (
    SELECT 1
    FROM BL_3NF.CE_Rentals cr
    WHERE cr.ride_SRC_id = dr.ride_SRC_id
);




WITH deduplicated_rentals AS (
    SELECT
        sbr.ride_id AS ride_SRC_id,
        sbr.start_date AS rental_event_dt,
        sbr.start_time AS rental_tm,
        sbr.end_date AS rental_end_dt,
        sbr.end_time AS rental_end_tm,
        sbr.season AS rental_season,
        sbr.ride_time_mins AS rental_duration,
        'sa_cash_rental' AS source_system,
        'src_bike_rental' AS source_table,
        ROW_NUMBER() OVER (PARTITION BY sbr.ride_id ORDER BY sbr.ride_id) AS row_num
    FROM sa_cash_rental.src_bike_rental sbr
)
INSERT INTO BL_3NF.CE_Rentals (
    ride_SRC_id, rental_event_dt, rental_tm, rental_end_dt, rental_end_tm, rental_season,
							rental_location_id, rental_customer_id, rental_cycle_id, rental_duration, source_system, source_table)
SELECT 
    COALESCE(dr.ride_SRC_id, 'n.a.'),
    COALESCE(dr.rental_event_dt::date, '1900-01-01'),
    COALESCE(dr.rental_tm::time, '24:00:00'),
    COALESCE(dr.rental_end_dt::date, '9999-01-01'),
    COALESCE(dr.rental_end_tm::time, '24:00:00'),
    COALESCE(dr.rental_season, 'n.a.'),
    COALESCE(cl.location_id, -1), 
    COALESCE(cc.customer_id, -1), 
    COALESCE(ccs.cycle_id, -1),
    COALESCE(dr.rental_duration::int, -1),
    COALESCE(dr.source_system, 'MANUAL'),
    COALESCE(dr.source_table, 'MANUAL')
FROM deduplicated_rentals dr
LEFT JOIN bl_3nf.ce_customers cc
    ON cc.customer_email_src_id = (SELECT sbr.email FROM sa_cash_rental.src_bike_rental sbr WHERE sbr.ride_id = dr.ride_SRC_id)
LEFT JOIN bl_3nf.ce_locations cl
    ON cl.location_coordinate_src_id = (SELECT sbr.start_id || sbr.end_id FROM sa_cash_rental.src_bike_rental sbr WHERE sbr.ride_id = dr.ride_SRC_id)
LEFT JOIN bl_3nf.ce_cycles_scd ccs 
    ON ccs.type_brand_src_id = (SELECT sbr.bike_type || sbr.cycle_brand FROM sa_cash_rental.src_bike_rental sbr WHERE sbr.ride_id = dr.ride_SRC_id)
WHERE dr.row_num = 1
AND NOT EXISTS (
    SELECT 1
    FROM BL_3NF.CE_Rentals cr
    WHERE cr.ride_SRC_id = dr.ride_SRC_id
);



INSERT INTO BL_3NF.CE_Payments (customer_payment_dt_SRC_id, payment_rental_id, payment_customer_id, payment_discount_percent,
    payment_amount, payment_dt, insert_date, update_dt, source_system, source_table)
SELECT 
    COALESCE(cr.rental_id, -1),
    COALESCE(cr.rental_id, -1),
    COALESCE(cc.customer_id, -1),
    COALESCE(charde_percent::decimal, -1),
    COALESCE(payment_amount::decimal, -1),
    COALESCE(payment_date::date, '1900-01-01'),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    COALESCE('sa_online_rental', 'MANUAL'),
    COALESCE('src_online_bike_rental', 'MANUAL')
FROM  bl_3nf.ce_customers cc
INNER JOIN sa_online_rental.src_online_bike_rental sobr
ON cc.customer_email_src_id = sobr.email
INNER JOIN bl_3nf.ce_rentals cr
ON cr.ride_src_id = sobr.online_ride_id 
AND NOT EXISTS (
    SELECT 1
    FROM bl_3nf.ce_payments
    WHERE bl_3nf.ce_payments.payment_rental_id = cr.rental_id);

   

 
INSERT INTO BL_3NF.CE_Payments (customer_payment_dt_SRC_id, payment_rental_id, payment_customer_id, payment_discount_percent,
								insert_date, update_dt, source_system, source_table)
SELECT 
    COALESCE(cr.rental_id, -1),
    COALESCE(cr.rental_id, -1),
    COALESCE(cc.customer_id, -1),
    COALESCE(charde_percent::decimal, -1),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    COALESCE('sa_online_rental', 'MANUAL'),
    COALESCE('src_online_bike_rental', 'MANUAL')
FROM  bl_3nf.ce_customers cc
INNER JOIN sa_cash_rental.src_bike_rental sbr
ON cc.customer_email_src_id = sbr.email
INNER JOIN bl_3nf.ce_rentals cr
ON cr.ride_src_id = sbr.ride_id 
AND NOT EXISTS (
    SELECT 1
    FROM bl_3nf.ce_payments
    WHERE bl_3nf.ce_payments.payment_rental_id = cr.rental_id);


COMMIT;


