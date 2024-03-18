
CREATE TABLE DIM_DATES (
    date_id INT PRIMARY KEY,
    full_date DATE,
    day_of_week VARCHAR(20),
    day_of_month INT,
    month_name VARCHAR(20),
    quarter INT,
    year INT,
    season VARCHAR(20)
);


INSERT INTO DIM_DATES (date_id, full_date, day_of_week, day_of_month, month_name, quarter, year, season)
SELECT 
    EXTRACT(YEAR FROM date_series.dt) * 10000 + EXTRACT(MONTH FROM date_series.dt) * 100 + EXTRACT(DAY FROM date_series.dt) AS date_id,
    date_series.dt AS full_date,
    TO_CHAR(date_series.dt, 'Day') AS day_of_week,
    EXTRACT(DAY FROM date_series.dt) AS day_of_month,
    TO_CHAR(date_series.dt, 'Month') AS month_name,
    EXTRACT(QUARTER FROM date_series.dt) AS quarter,
    EXTRACT(YEAR FROM date_series.dt) AS year,
    CASE 
        WHEN EXTRACT(MONTH FROM date_series.dt) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM date_series.dt) IN (6, 7, 8) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM date_series.dt) IN (9, 10, 11) THEN 'Fall'
        ELSE 'Winter'
    END AS season
FROM (
    SELECT GENERATE_SERIES(DATE '2020-01-01', DATE '2025-12-31', INTERVAL '1 DAY') AS dt
) AS date_series;





CREATE TABLE DIM_TIMES (
    time_id int PRIMARY KEY,
    full_time TIME,
    hour INT,
    minute INT,
    second INT
);



INSERT INTO DIM_TIMES (time_id, full_time, hour, minute, second)
SELECT 
	(hour * 10000) + (minute * 100) + second AS time_id,
    make_time(hour, minute, second) as full_time,
    hour,
    minute,
    second
FROM
    generate_series(0, 23) as hour,
    generate_series(0, 59) as minute,
    generate_series(0, 59) as second;



