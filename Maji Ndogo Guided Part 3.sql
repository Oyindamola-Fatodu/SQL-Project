--  A. Are there any specific provinces, or towns where some sources are more abundant?
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

-- These were the sites our surveyors collected additional information for, but they happened at the same source/location.
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
    
-- Add the visits.visit_count = 1 as a filter.
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
    
    
CREATE TABLE Project_progress (
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

INSERT INTO project_progress (source_id, Address, Town, Province, Source_type)
SELECT
	ws.source_id,
	l.address,
	l.town_name,
	l.province_name,
	ws.type_of_water_source
FROM
	water_source AS ws
LEFT JOIN
	well_pollution AS wp ON ws.source_id = wp.source_id
INNER JOIN
visits AS v ON ws.source_id = v.source_id
INNER JOIN
	location AS l ON l.location_id = v.location_id
WHERE 
	v.visit_count = 1
    AND (
		(ws.type_of_water_source = 'well' AND wp.description != 'Clean')
        OR
			ws.type_of_water_source IN ('tap_in_home_broken', 'river')
		 OR
			(ws.type_of_water_source = 'shared_tap' AND v.time_in_queue >= 30)
		);


UPDATE project_progress_copy
JOIN
well_pollution AS wp ON project_progress_copy.source_id = wp.source_id
SET Improvement =	CASE
        WHEN wp.results = "Contaminated:Biological" THEN "Install UV and RO filter"
            WHEN wp.results = "Contaminated: Chemical" THEN "Install RO filter"
            ELSE NULL
        END
WHERE source_type = "well";



 CASE 
			WHEN wp.results = "Contaminated:Biological" THEN "Install UV and RO filter"
            WHEN wp.results = "Contaminated: Chemical" THEN "Install RO filter"
            ELSE NULL
        END, ws.source_id
	
        
INSERT INTO project_progress_copy1 (Source_id, Address, Town, Province, Source_type,Improvement)
SELECT
water_source.source_id,
location.address,
location.town_name,
location.province_name,
water_source.type_of_water_source,
CASE
        WHEN well_pollution.results = 'Contaminated:Biological' THEN 'Install UV and RO filter'
        WHEN well_pollution.results = 'Contaminated: Chemical' THEN 'Install RO filter'
        WHEN
            type_of_water_source = 'shared_tap'
                AND time_in_queue >= 30
        THEN
            CONCAT('Install ',
                    FLOOR(time_in_queue / 30),
                    ' taps nearby')
        ELSE NULL
    END AS Improvement
FROM
water_source
LEFT JOIN
well_pollution ON water_source.source_id = well_pollution.source_id
INNER JOIN
visits ON water_source.source_id = visits.source_id
INNER JOIN
location ON location.location_id = visits.location_id
WHERE visits.visit_count = 1
AND (
	(type_of_water_source = "shared_tap" AND time_in_queue >= 30)
OR (results != "clean")
OR (type_of_water_source IN ("river", "tap_in_home_broken"))
);



SET SQL_SAFE_UPDATES = 0;
UPDATE project_progress_copy
SET improvement = 'Drill Well'
WHERE source_type  = 'river';

INSERT INTO project_progress_copy (Improvement)
SELECT 
    CASE
        WHEN
            type_of_water_source = 'shared_tap'
                AND time_in_queue >= 30
        THEN
            CONCAT('Install ',
                    FLOOR(time_in_queue / 30),
                    ' taps nearby')
        ELSE NULL
    END AS Improvement
FROM
    water_source
        LEFT JOIN
    well_pollution ON water_source.source_id = well_pollution.source_id
        INNER JOIN
    visits ON water_source.source_id = visits.source_id
        INNER JOIN
    location ON location.location_id = visits.location_id
WHERE
    visits.visit_count = 1
        AND ((type_of_water_source = 'shared_tap'
        AND time_in_queue >= 30)
        OR (results != 'clean')
        OR (type_of_water_source IN ('river' , 'tap_in_home_broken')));






INSERT INTO project_progress(Source_id, Address, Town, Province, Source_type, Improvement)
SELECT
water_source.source_id,
location.address,
location.town_name,
location.province_name,
water_source.type_of_water_source,
CASE
        WHEN well_pollution.results = 'Contaminated:Biological' THEN 'Install UV and RO filter'
        WHEN well_pollution.results = 'Contaminated: Chemical' THEN 'Install RO filter'
        ELSE NULL
    END AS Improvement
FROM
water_source
LEFT JOIN
well_pollution ON water_source.source_id = well_pollution.source_id
INNER JOIN
visits ON water_source.source_id = visits.source_id
INNER JOIN
location ON location.location_id = visits.location_id
WHERE visits.visit_count = 1
AND (
	(type_of_water_source = "shared_tap" AND time_in_queue >= 30)
OR (results != "clean")
OR (type_of_water_source IN ("river", "tap_in_home_broken"))
);