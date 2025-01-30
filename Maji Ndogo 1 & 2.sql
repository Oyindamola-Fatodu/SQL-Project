USE md_water_services;
SELECT 
    CONCAT(LOWER(REPLACE(employee_name, " ",".")), "@ndogowater.gov") AS email_address
FROM
    employee;

SET SQL_SAFE_UPDATES = 0;

UPDATE employee
SET email = CONCAT(LOWER(REPLACE(employee_name, " ",".")), "@ndogowater.gov");

SELECT 
    *
FROM
    employee;
    
SELECT 
    LENGTH(TRIM(phone_number)) AS aa
FROM
    employee;
UPDATE employee
SET phone_number = TRIM(phone_number);

-- Honouring the workers
SELECT 
    town_name, COUNT(town_name) AS num_of_people
FROM
    employee
GROUP BY town_name;

SELECT 
    assigned_employee_id,
    sum(visit_count) AS number_of_visits
FROM
    visits
GROUP BY assigned_employee_id
ORDER BY number_of_visits DESC
LIMIT 3;

SELECT *
FROM employee
WHERE assigned_employee_id IN (1,30,34);

-- Analysing locations

SELECT 
	town_name,
    count(town_name) AS num_of_records
FROM location
GROUP BY town_name
ORDER BY num_of_records DESC;

SELECT 
	province_name,
    count(town_name) AS num_of_records
FROM location
GROUP BY province_name
ORDER BY num_of_records DESC;

SELECT
	province_name,
    town_name,
    COUNT(town_name) AS records_per_town
FROM location
GROUP BY province_name, town_name
ORDER BY province_name, records_per_town DESC;

SELECT 
	COUNT(location_type),
    location_type
FROM location
GROUP BY location_type;

-- Diving into the sources

SELECT *
FROM water_source;

SELECT
	SUM(number_of_people_served)
FROM water_source;

SELECT 
    type_of_water_source, COUNT(type_of_water_source) AS num
FROM
    water_source
GROUP BY type_of_water_source;

SELECT 
    type_of_water_source, ROUND(AVG(number_of_people_served)) AS num_served
FROM
    water_source
GROUP BY type_of_water_source;

SELECT
	type_of_water_source,
    SUM(number_of_people_served) AS num_served
FROM water_source
GROUP BY type_of_water_source
ORDER BY num_served DESC;


SELECT
	type_of_water_source,
    ROUND((SUM(number_of_people_served) * 100)/27628140) AS percnt_served
FROM water_source
GROUP BY type_of_water_source
ORDER BY percnt_served DESC;

-- Start of a solution

SELECT
	type_of_water_source,
    SUM(number_of_people_served) AS num_served,
    RANK() OVER( 
				ORDER BY SUM(number_of_people_served) DESC) AS priority_rank
FROM water_source
WHERE type_of_water_source != "tap_in_home"
GROUP BY type_of_water_source;

SELECT
	source_id,
    type_of_water_source,
    SUM(number_of_people_served) AS num_served,
    RANK() OVER( 
				ORDER BY SUM(number_of_people_served) DESC, type_of_water_source) AS priority_rank
FROM water_source
WHERE type_of_water_source != "tap_in_home"
GROUP BY type_of_water_source, source_id;

-- Analysing queues

SELECT *
FROM visits;

SELECT 
DATEDIFF(MAX(time_of_record),MIN(time_of_record))
FROM visits;

SELECT
	AVG(NULLIF(time_in_queue,0))
FROM visits;

SELECT 
	DAYNAME(time_of_record) AS day_of_the_week,
    ROUND(AVG(NULLIF(time_in_queue,0))) AS average_time_in_queue
FROM visits
GROUP BY day_of_the_week;

SELECT 
	TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
    ROUND(AVG(NULLIF(time_in_queue,0))) AS average_time_in_queue
FROM visits
GROUP BY hour_of_day
ORDER BY hour_of_day, average_time_in_queue DESC;

SELECT 
    TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
    DAYNAME(time_of_record),
    CASE
        WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
        ELSE NULL
    END AS Sunday
FROM
    visits
WHERE
    time_in_queue != 0; -- this exludes other sources with 0 queue times
    
SELECT 
    TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
    ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Sunday,
    ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Monday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Monday,
    ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Tuesday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Tuesday,
    ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Wednesday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Wednesday,
    ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Thursday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Thursday,
    ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Friday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Friday,
    ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Saturday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Saturday
FROM
    visits
WHERE
    time_in_queue != 0
GROUP BY hour_of_day
ORDER BY hour_of_day;

SELECT 
    CONCAT(LOWER(REPLACE(employee_name, " ",".")), "@ndogowater.gov") AS email_address
FROM
    employee;

SET SQL_SAFE_UPDATES = 0;

UPDATE employee
SET email = CONCAT(LOWER(REPLACE(employee_name, " ",".")), "@ndogowater.gov");

SELECT 
    *
FROM
    employee;
    
SELECT 
    LENGTH(TRIM(phone_number)) AS aa
FROM
    employee;
UPDATE employee
SET phone_number = TRIM(phone_number);

-- Honouring the workers
SELECT 
    town_name, COUNT(town_name) AS num_of_people
FROM
    employee
GROUP BY town_name;

SELECT 
    assigned_employee_id,
    sum(visit_count) AS number_of_visits
FROM
    visits
GROUP BY assigned_employee_id
ORDER BY number_of_visits DESC
LIMIT 3;

SELECT *
FROM employee
WHERE assigned_employee_id IN (1,30,34);

-- Analysing locations

SELECT 
	town_name,
    count(town_name) AS num_of_records
FROM location
GROUP BY town_name
ORDER BY num_of_records DESC;

SELECT 
	province_name,
    count(town_name) AS num_of_records
FROM location
GROUP BY province_name
ORDER BY num_of_records DESC;

SELECT
	province_name,
    town_name,
    COUNT(town_name) AS records_per_town
FROM location
GROUP BY province_name, town_name
ORDER BY province_name, records_per_town DESC;

SELECT 
	COUNT(location_type),
    location_type
FROM location
GROUP BY location_type;

-- Diving into the sources

SELECT *
FROM water_source;

SELECT
	SUM(number_of_people_served)
FROM water_source;

SELECT 
    type_of_water_source, COUNT(type_of_water_source) AS num
FROM
    water_source
GROUP BY type_of_water_source;

SELECT 
    type_of_water_source, ROUND(AVG(number_of_people_served)) AS num_served
FROM
    water_source
GROUP BY type_of_water_source;

SELECT
	type_of_water_source,
    SUM(number_of_people_served) AS num_served
FROM water_source
GROUP BY type_of_water_source
ORDER BY num_served DESC;


SELECT
	type_of_water_source,
    ROUND((SUM(number_of_people_served) * 100)/27628140) AS percnt_served
FROM water_source
GROUP BY type_of_water_source
ORDER BY percnt_served DESC;

-- Start of a solution

SELECT
	type_of_water_source,
    SUM(number_of_people_served) AS num_served,
    RANK() OVER( 
				ORDER BY SUM(number_of_people_served) DESC) AS priority_rank
FROM water_source
WHERE type_of_water_source != "tap_in_home"
GROUP BY type_of_water_source;

SELECT
	source_id,
    type_of_water_source,
    SUM(number_of_people_served) AS num_served,
    RANK() OVER( 
				ORDER BY SUM(number_of_people_served) DESC, type_of_water_source) AS priority_rank
FROM water_source
WHERE type_of_water_source != "tap_in_home"
GROUP BY type_of_water_source, source_id;

-- Analysing queues

SELECT *
FROM visits;

SELECT 
DATEDIFF(MAX(time_of_record),MIN(time_of_record))
FROM visits;

SELECT
	AVG(NULLIF(time_in_queue,0))
FROM visits;

SELECT 
	DAYNAME(time_of_record) AS day_of_the_week,
    ROUND(AVG(NULLIF(time_in_queue,0))) AS average_time_in_queue
FROM visits
GROUP BY day_of_the_week;

SELECT 
	TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
    ROUND(AVG(NULLIF(time_in_queue,0))) AS average_time_in_queue
FROM visits
GROUP BY hour_of_day
ORDER BY hour_of_day, average_time_in_queue DESC;

SELECT 
    TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
    DAYNAME(time_of_record),
    CASE
        WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
        ELSE NULL
    END AS Sunday
FROM
    visits
WHERE
    time_in_queue != 0; -- this exludes other sources with 0 queue times
    
SELECT 
    TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
    ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Sunday,
    ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Monday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Monday,
    ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Tuesday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Tuesday,
    ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Wednesday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Wednesday,
    ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Thursday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Thursday,
    ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Friday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Friday,
    ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Saturday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Saturday
FROM
    visits
WHERE
    time_in_queue != 0
GROUP BY hour_of_day
ORDER BY hour_of_day;

DROP TABLE IF EXISTS `auditor_report`;
CREATE TABLE `auditor_report` (
`location_id` VARCHAR(32),
`type_of_water_source` VARCHAR(64),
`true_water_source_score` int DEFAULT NULL,
`statements` VARCHAR(255)
);

-- Integrating the report
-- Grab the location_id and true_water_source_score columns from auditor_report.
SELECT
	location_id,
    true_water_source_score
FROM
	auditor_report;
    
-- Joining the visits table to the auditor_report table. Make sure to grab subjective_quality_score, record_id and location_id.
SELECT
	a.location_id AS audit_location,
    a.true_water_source_score,
	v.location_id AS visit_location,
    v.record_id,
    w.subjective_quality_score
FROM 
	auditor_report AS a
INNER JOIN
	 visits AS v
ON
	v.location_id = a.location_id;
    
-- Then JOIN the visits table and the water_quality table, using the record_id as the connecting key.
SELECT
	a.location_id AS audit_location,
    a.true_water_source_score,
	v.location_id AS visit_location,
    v.record_id,
    w.subjective_quality_score
FROM 
	auditor_report AS a
INNER JOIN
	 visits AS v
ON
	v.location_id = a.location_id
INNER JOIN
	water_quality AS w
ON
	v.record_id = w.record_id;

-- Let's leave record_id and rename the scores to surveyor_score and auditor_score to make it clear which scores we're looking at in the results set.
SELECT
	a.location_id,
    v.record_id,
    a.true_water_source_score AS auditor_score,
    w.subjective_quality_score AS surveyor_score
FROM 
	auditor_report AS a
INNER JOIN
	 visits AS v
ON
	v.location_id = a.location_id
INNER JOIN
	water_quality AS w
ON
	v.record_id = w.record_id;

-- check if the auditor's and exployees' scores agree.    
-- Ensure the visits is not duplicated
SELECT
	a.location_id,
    v.record_id,
    a.true_water_source_score AS auditor_score,
    w.subjective_quality_score AS surveyor_score
FROM 
	auditor_report AS a
INNER JOIN
	 visits AS v
ON
	v.location_id = a.location_id
INNER JOIN
	water_quality AS w
ON
	v.record_id = w.record_id
WHERE
	w.subjective_quality_score = a.true_water_source_score
    AND v.visit_count = 1;

-- 1518 of 1620 rows where returned, check the issue with the missing rows
SELECT
	a.location_id,
    v.record_id,
    a.true_water_source_score AS auditor_score,
    w.subjective_quality_score AS surveyor_score
FROM 
	auditor_report AS a
INNER JOIN
	 visits AS v
ON
	v.location_id = a.location_id
INNER JOIN
	water_quality AS w
ON
	v.record_id = w.record_id
WHERE
	w.subjective_quality_score != a.true_water_source_score
    AND v.visit_count = 1;
    
-- grab the type_of_water_source column from the water_source table and call it survey_source, using the source_id column to JOIN. Also select the type_of_water_source from the auditor_report table, and call it auditor_source.
SELECT
	a.location_id,
    v.record_id,
    a.true_water_source_score AS auditor_score,
    w.subjective_quality_score AS surveyor_score,
    a.type_of_water_source AS auditor_source
FROM 
	auditor_report AS a
INNER JOIN
	 visits AS v
ON
	v.location_id = a.location_id
INNER JOIN
	water_quality AS w
ON
	v.record_id = w.record_id
WHERE
	w.subjective_quality_score != a.true_water_source_score
    AND v.visit_count = 1;
    
-- Linking records to employees
SELECT
	a.location_id,
    v.record_id,
    e.employee_name,
    a.true_water_source_score AS auditor_score,
    w.subjective_quality_score AS surveyor_score,
    a.type_of_water_source AS auditor_source
FROM 
	auditor_report AS a
INNER JOIN
	 visits AS v
ON
	v.location_id = a.location_id
INNER JOIN
	water_quality AS w
ON
	v.record_id = w.record_id
INNER JOIN
	employee AS e
ON
	v.assigned_employee_id = e.assigned_employee_id
WHERE
	w.subjective_quality_score != a.true_water_source_score
    AND v.visit_count = 1;
    
-- we can just call that CTE like it was a table. Call it something like Incorrect_records. Once you are done, check if this query SELECT * FROM Incorrect_records, gets the same table back
WITH Incorrect_records AS(
		SELECT
			a.location_id,
			v.record_id,
			e.employee_name,
			a.true_water_source_score AS auditor_score,
			w.subjective_quality_score AS surveyor_score,
			a.type_of_water_source AS auditor_source
		FROM 
			auditor_report AS a
		INNER JOIN
			 visits AS v
		ON
			v.location_id = a.location_id
		INNER JOIN
			water_quality AS w
		ON
			v.record_id = w.record_id
		INNER JOIN
			employee AS e
		ON
			v.assigned_employee_id = e.assigned_employee_id
		WHERE
			w.subjective_quality_score != a.true_water_source_score
			AND v.visit_count = 1
)
SELECT 
	*
FROM 
	Incorrect_records;
    
-- Let's first get a unique list of employees from this table.
WITH Incorrect_records AS(
		SELECT
			a.location_id,
			v.record_id,
			e.employee_name,
			a.true_water_source_score AS auditor_score,
			w.subjective_quality_score AS surveyor_score,
			a.type_of_water_source AS auditor_source
		FROM 
			auditor_report AS a
		INNER JOIN
			 visits AS v
		ON
			v.location_id = a.location_id
		INNER JOIN
			water_quality AS w
		ON
			v.record_id = w.record_id
		INNER JOIN
			employee AS e
		ON
			v.assigned_employee_id = e.assigned_employee_id
		WHERE
			w.subjective_quality_score != a.true_water_source_score
			AND v.visit_count = 1
)
SELECT 
	DISTINCT employee_name
FROM 
	Incorrect_records;
    
-- let's try to calculate how many mistakes each employee made
WITH Incorrect_records AS(
		SELECT
			a.location_id,
			v.record_id,
			e.employee_name,
			a.true_water_source_score AS auditor_score,
			w.subjective_quality_score AS surveyor_score,
			a.type_of_water_source AS auditor_source
		FROM 
			auditor_report AS a
		INNER JOIN
			 visits AS v
		ON
			v.location_id = a.location_id
		INNER JOIN
			water_quality AS w
		ON
			v.record_id = w.record_id
		INNER JOIN
			employee AS e
		ON
			v.assigned_employee_id = e.assigned_employee_id
		WHERE
			w.subjective_quality_score != a.true_water_source_score
			AND v.visit_count = 1
)
SELECT 
	employee_name,
    COUNT(employee_name) AS employee_count
FROM 
	Incorrect_records
GROUP BY 
	employee_name
ORDER BY
	employee_count DESC;
    

-- Gathering some evidence
WITH Incorrect_records AS (
		SELECT
			a.location_id,
			v.record_id,
			e.employee_name,
			a.true_water_source_score AS auditor_score,
			w.subjective_quality_score AS surveyor_score,
			a.type_of_water_source AS auditor_source
		FROM 
			auditor_report AS a
		INNER JOIN
			 visits AS v
		ON
			v.location_id = a.location_id
		INNER JOIN
			water_quality AS w
		ON
			v.record_id = w.record_id
		INNER JOIN
			employee AS e
		ON
			v.assigned_employee_id = e.assigned_employee_id
		WHERE
			w.subjective_quality_score != a.true_water_source_score
			AND v.visit_count = 1),
	error_count AS (
		SELECT 
			employee_name,
			COUNT(employee_name) AS number_of_mistakes
		FROM 
			Incorrect_records
		GROUP BY
			employee_name
)
SELECT
    AVG(number_of_mistakes)
FROM
	error_count;
    

WITH Incorrect_records AS (
		SELECT
			a.location_id,
			v.record_id,
			e.employee_name,
			a.true_water_source_score AS auditor_score,
			w.subjective_quality_score AS surveyor_score,
			a.type_of_water_source AS auditor_source
		FROM 
			auditor_report AS a
		INNER JOIN
			 visits AS v
		ON
			v.location_id = a.location_id
		INNER JOIN
			water_quality AS w
		ON
			v.record_id = w.record_id
		INNER JOIN
			employee AS e
		ON
			v.assigned_employee_id = e.assigned_employee_id
		WHERE
			w.subjective_quality_score != a.true_water_source_score
			AND v.visit_count = 1),
	error_count AS (
		SELECT 
			employee_name,
			COUNT(employee_name) AS number_of_mistakes
		FROM 
			Incorrect_records
		GROUP BY
			employee_name
)
SELECT
	employee_name,
	number_of_mistakes
FROM
	error_count
WHERE
	number_of_mistakes > (SELECT
							AVG(number_of_mistakes)
						FROM
							error_count);
                            
--  replace WITH with CREATE VIEW
CREATE VIEW Incorrect_records AS (
		SELECT
			a.location_id,
			v.record_id,
			e.employee_name,
			a.true_water_source_score AS auditor_score,
			w.subjective_quality_score AS surveyor_score,
			a.type_of_water_source AS auditor_source,
            a.statements AS auditor_statements
		FROM 
			auditor_report AS a
		INNER JOIN
			 visits AS v
		ON
			v.location_id = a.location_id
		INNER JOIN
			water_quality AS w
		ON
			v.record_id = w.record_id
		INNER JOIN
			employee AS e
		ON
			v.assigned_employee_id = e.assigned_employee_id
		WHERE
			w.subjective_quality_score != a.true_water_source_score
			AND v.visit_count = 1);
            
-- Next, we convert the query error_count, we made earlier, into a CTE.
WITH error_count AS ( -- This CTE calculates the number of mistakes each employee made
		SELECT
			employee_name,
			COUNT(employee_name) AS number_of_mistakes
		FROM
			Incorrect_records
-- /* Incorrect_records is a view that joins the audit report to the database for records where the auditor and employees scores are different*
		GROUP BY
			employee_name)
-- Query
SELECT 
	* 
FROM 
	error_count;
    
-- calculate the average of the number_of_mistakes in error_count
WITH error_count AS ( -- This CTE calculates the number of mistakes each employee made
		SELECT
			employee_name,
			COUNT(employee_name) AS number_of_mistakes
		FROM
			Incorrect_records
-- /* Incorrect_records is a view that joins the audit report to the database for records where the auditor and employees scores are different*
		GROUP BY
			employee_name)
-- Query
SELECT 
	AVG(number_of_mistakes)
FROM 
	error_count;
    
    
WITH error_count AS ( -- This CTE calculates the number of mistakes each employee made
		SELECT
			employee_name,
			COUNT(employee_name) AS number_of_mistakes
		FROM
			Incorrect_records
-- /* Incorrect_records is a view that joins the audit report to the database for records where the auditor and employees scores are different*
		GROUP BY
			employee_name)
-- Query
SELECT 
	* 
FROM 
	error_count;
    
-- calculate the average of the number_of_mistakes in error_count
CREATE VIEW  error_count AS (
		SELECT
			employee_name,
			COUNT(employee_name) AS number_of_mistakes
		FROM
			Incorrect_records
		GROUP BY
			employee_name);

CREATE VIEW suspect_list AS(
		SELECT 
			employee_name,
			number_of_mistakes
		FROM 
		error_count
		WHERE
		number_of_mistakes > (
						SELECT
							AVG(number_of_mistakes)
						FROM 
							error_count)
);

-- Step 1 J o i n i n g p i e c e s t o g e t h e r
--  A. Are there any specific provinces, or towns where some sources are more abundant?
-- a. Start by joining location to visits.
SELECT
	l.province_name,
    l.town_name,
    v.visit_count,
    v.location_id
FROM
	visits AS v
JOIN
	location AS l
ON
	v.location_id = l.location_id;

-- b Now, we can join the water_source table on the key shared between water_source and visits.
SELECT
	l.province_name,
    l.town_name,
    v.visit_count,
    v.location_id,
    type_of_water_source, 
    number_of_people_served
FROM
	visits AS v
JOIN
	location AS l
ON
	v.location_id = l.location_id
JOIN
	water_source AS ws
ON
	v.source_id = ws.source_id;

-- These were the sites our surveyors collected additional information for, but they happened at the same source/location. For example, add this to your query: WHERE visits.location_id = 'AkHa00103'
SELECT
	l.province_name,
    l.town_name,
    v.visit_count,
    v.location_id,
    type_of_water_source, 
    number_of_people_served
FROM
	visits AS v
JOIN
	location AS l
ON
	v.location_id = l.location_id
JOIN
	water_source AS ws
ON
	v.source_id = ws.source_id
WHERE 
	v.location_id = 'AkHa00103';
    
-- Remove WHERE visits.location_id = 'AkHa00103' and add the visits.visit_count = 1 as a filter.
SELECT
	l.province_name,
    l.town_name,
    v.visit_count,
    v.location_id,
    type_of_water_source, 
    number_of_people_served
FROM
	visits AS v
JOIN
	location AS l
ON
	v.location_id = l.location_id
JOIN
	water_source AS ws
ON
	v.source_id = ws.source_id
WHERE 
	v.visit_count= 1;
    
-- Ok, now that we verified that the table is joined correctly, we can remove the location_id and visit_count columns.
-- Add the location_type column from location and time_in_queue from visits to our results set.
SELECT
	l.province_name,
    l.town_name,
    v.time_in_queue,
    l.location_type,
    ws.type_of_water_source, 
    ws.number_of_people_served,
    wp.results
FROM
	visits AS v
JOIN
	location AS l
ON
	v.location_id = l.location_id
JOIN
	water_source AS ws
ON
	v.source_id = ws.source_id
LEFT JOIN
	well_pollution 	AS wp
ON
	ws.source_id = wp.source_id
WHERE
	v.visit_count = 1;
    
    
CREATE VIEW combined_analysis_table AS (
							SELECT
								l.province_name,
								l.town_name,
								v.time_in_queue,
								l.location_type,
								ws.type_of_water_source, 
								ws.number_of_people_served,
								wp.results
							FROM
								visits AS v
							JOIN
								location AS l
							ON
								v.location_id = l.location_id
							JOIN
								water_source AS ws
							ON
								v.source_id = ws.source_id
							LEFT JOIN
								well_pollution 	AS wp
							ON
								ws.source_id = wp.source_id
							WHERE
								v.visit_count = 1);

-- Step 2 The last analysis
-- This time, we want to break down our data into provinces or towns and source types.
-- Create a CTE calculates the population of each province
WITH province_totals AS (-- This CTE calculates the population of each province
			SELECT
				province_name,
				SUM(number_of_people_served) AS total_ppl_serv
			FROM
				combined_analysis_table
			GROUP BY
				province_name
)
SELECT
	ct.province_name,
-- These case statements create columns for each type of source.
-- The results are aggregated and percentages are calculated
	ROUND((SUM(CASE WHEN type_of_water_source = 'river'
	THEN number_of_people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS river,
	ROUND((SUM(CASE WHEN type_of_water_source= 'shared_tap'
	THEN number_of_people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS shared_tap,
	ROUND((SUM(CASE WHEN type_of_water_source = 'tap_in_home'
	THEN number_of_people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS tap_in_home,
	ROUND((SUM(CASE WHEN type_of_water_source = 'tap_in_home_broken'
	THEN number_of_people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS tap_in_home_broken,
	ROUND((SUM(CASE WHEN type_of_water_source = 'well'
	THEN number_of_people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS well
FROM
	combined_analysis_table ct
JOIN
	province_totals pt 
    ON ct.province_name = pt.province_name
GROUP BY
	ct.province_name
ORDER BY
	ct.province_name;
    
-- Let's aggregate the data per town now.
WITH town_totals AS (-- This CTE calculates the population of each province
			SELECT
				province_name,
                town_name,
				SUM(number_of_people_served) AS total_ppl_serv
			FROM
				combined_analysis_table
			GROUP BY
				province_name, town_name
)
SELECT
	ct.province_name,
    ct.town_name,
-- These case statements create columns for each type of source.
-- The results are aggregated and percentages are calculated
	ROUND((SUM(CASE WHEN type_of_water_source = 'river'
	THEN number_of_people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS river,
	ROUND((SUM(CASE WHEN type_of_water_source= 'shared_tap'
	THEN number_of_people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS shared_tap,
	ROUND((SUM(CASE WHEN type_of_water_source = 'tap_in_home'
	THEN number_of_people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home,
	ROUND((SUM(CASE WHEN type_of_water_source = 'tap_in_home_broken'
	THEN number_of_people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home_broken,
	ROUND((SUM(CASE WHEN type_of_water_source = 'well'
	THEN number_of_people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS well
FROM
	combined_analysis_table ct
JOIN
	town_totals tt ON ct.province_name = tt.province_name AND ct.town_name = tt.town_name
GROUP BY
	ct.province_name, ct.town_name
ORDER BY
	ct.town_name;
    
CREATE TEMPORARY TABLE town_aggregated_water_access    
WITH town_totals AS (-- This CTE calculates the population of each province
			SELECT
				province_name,
                town_name,
				SUM(number_of_people_served) AS total_ppl_serv
			FROM
				combined_analysis_table
			GROUP BY
				province_name, town_name
)
SELECT
	ct.province_name,
    ct.town_name,
-- These case statements create columns for each type of source.
-- The results are aggregated and percentages are calculated
	ROUND((SUM(CASE WHEN type_of_water_source = 'river'
	THEN number_of_people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS river,
	ROUND((SUM(CASE WHEN type_of_water_source= 'shared_tap'
	THEN number_of_people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS shared_tap,
	ROUND((SUM(CASE WHEN type_of_water_source = 'tap_in_home'
	THEN number_of_people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home,
	ROUND((SUM(CASE WHEN type_of_water_source = 'tap_in_home_broken'
	THEN number_of_people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home_broken,
	ROUND((SUM(CASE WHEN type_of_water_source = 'well'
	THEN number_of_people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS well
FROM
	combined_analysis_table ct
JOIN
	town_totals tt ON ct.province_name = tt.province_name AND ct.town_name = tt.town_name
GROUP BY
	ct.province_name, ct.town_name
ORDER BY
	ct.town_name;
    
    
SELECT 
	*
FROM
	town_aggregated_water_access;
    
    
SELECT
	town_name,
    province_name,
    (tap_in_home_broken / (tap_in_home + tap_in_home_broken)) * 100 AS Pct_broken_tap
FROM
	town_aggregated_water_access;
    
    
CREATE TABLE Project_progress_copy (
Project_id SERIAL PRIMARY KEY,
/* Project_id −− Unique key for sources in case we visit the same source more than once in the future.

*/
source_id VARCHAR(20) NOT NULL REFERENCES water_source(source_id) ON DELETE CASCADE ON UPDATE CASCADE,
--  source_id −− Each of the sources we want to improve should exist, and should refer to the source table. This ensures data integrity.
Address VARCHAR(50),  -- Street address
Town VARCHAR(30),
Province VARCHAR(30),
Source_type VARCHAR(50),
Improvement VARCHAR(50), -- What the engineers should do at that place
Source_status VARCHAR(50) DEFAULT 'Backlog' CHECK (Source_status IN ('Backlog', 'In progress', 'Complete')),
-- (Source_status We want to limit the type of information engineers can give us, so we limit Source_status. By DEFAULT all projects are in the "Backlog" which is like a TODO list.
-- CHECK() ensures only those three options will be accepted. This helps to maintain clean data.
Date_of_completion DATE, -- Engineers will add this the day the source has been upgraded.
Comments TEXT -- Engineers can leave comments. We use a TEXT type that has no limit on char length
);

INSERT INTO project_progress (
	Source_id,
    Address,
    Province,
    Town, 
    Source_type
)
SELECT
	l.address AS Address,
    l.town_name AS Town,
    l.province_name AS Province,
    ws.source_id AS source_id,
    ws.type_of_water_source AS Source_type
FROM
	water_source AS ws
LEFT JOIN 
	well_pollution AS wp
ON 
	ws.source_id = wp.source_id
JOIN
	visits AS v
ON 
	ws.source_id = v.source_id
JOIN
		location AS l
ON
	v.location_id = l.location_id
WHERE 
	v.visit_count = 1
    AND (
		(ws.type_of_water_source = 'well' AND wp.description != 'Clean')
        OR
			ws.type_of_water_source IN ('tap_in_home_broken', 'river')
		 OR
			(ws.type_of_water_source = 'shared_tap' AND v.time_in_queue >= 30)
		);
        
        
INSERT INTO project_progress_copy (Improvement, source_id)
SELECT 
		CASE 
			WHEN wp.results = "Contaminated:Biological" THEN "Install UV and RO filter"
            WHEN wp.results = "Contaminated: Chemical" THEN "Install RO filter"
		ELSE NULL
        END 
FROM water_source AS ws
LEFT JOIN well_pollution AS wp
ON ws.source_id = wp.source_id
INNER JOIN
visits AS v ON ws.source_id = v.source_id
INNER JOIN
location AS l ON l.location_id = v.location_id
WHERE v.visit_count = 1
AND (
		(ws.type_of_water_source = 'well' AND wp.description != 'Clean')
        OR
			ws.type_of_water_source IN ('tap_in_home_broken', 'river')
		 OR
			(ws.type_of_water_source = 'shared_tap' AND v.time_in_queue >= 30)
		);
