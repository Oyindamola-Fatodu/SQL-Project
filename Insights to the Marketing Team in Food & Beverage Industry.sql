-- PRIMARY INSIGHT
-- 1) Demographic Insights
-- a. Who prefers energy drink more?
SELECT 
    d.Gender, 
    COUNT(f.Respondent_ID) AS energy_drink_count
FROM 
    dim_repondents AS d
JOIN 
    fact_survey_responses AS f 
ON 
	d.respondent_ID = f.respondent_ID
GROUP BY 
    d.Gender
ORDER BY 
    energy_drink_count DESC
LIMIT 1;

-- b. Which age group prefers energy drinks more?
SELECT 
	d.Age, 
    COUNT(f.Respondent_ID) AS age_group_count
FROM
	fact_survey_responses AS f
JOIN
	dim_repondents AS d
ON
	d.respondent_ID = f.respondent_ID
GROUP BY 
	Age
ORDER BY
	age_group_count DESC
LIMIT 1;

-- c. Which type of marketing reaches the most Youth (15-30)?
SELECT
	COUNT(f.Marketing_channels) AS channel_count,
    f.Marketing_channels
FROM 
	fact_survey_responses AS f
JOIN
	dim_repondents AS d
ON
	f.respondent_ID = d.respondent_ID
WHERE
	d.Age BETWEEN 15 AND 30
GROUP BY 
	f.Marketing_channels
ORDER BY
	channel_count DESC;
   
-- 2) Consumer Preferences
-- a. What are the preferred ingredients of energy drinks among respondents?
SELECT 
     Ingredients_expected,
     COUNT(Respondent_ID) AS preferred_ingredients
FROM
	fact_survey_responses
GROUP BY 
	Ingredients_expected
ORDER BY preferred_ingredients DESC;

-- b. What packaging preferences do respondents have for energy drinks?
SELECT 
     DISTINCT(Packaging_preference)
FROM
	fact_survey_responses;
    
-- 3) Competition Analysis
-- a. Who are the current market leaders?
SELECT 
	Current_brands,
	COUNT(Current_brands) AS current_market_leaders
FROM
	fact_survey_responses
GROUP BY
	Current_brands
ORDER BY
	current_market_leaders DESC;

-- b. What are the primary reasons consumers prefer those brands over ours?
SELECT 
    CASE 
        WHEN Current_brands IN ('Cola-Coka', 'Bepsi', 'Gangster', 'Blue Bull') THEN 'Current Brands'
        WHEN Current_brands = 'Codex' THEN 'Codex'
    END AS Brand_Type,
    Reasons_for_choosing_brands,
    COUNT(Current_brands) AS count_of_preferences
FROM 
    fact_survey_responses
WHERE 
    Current_brands IN ('Cola-Coka', 'Bepsi', 'Gangster', 'Blue Bull', 'Codex')
GROUP BY 
    Brand_Type, Reasons_for_choosing_brands
ORDER BY 
    count_of_preferences DESC;

-- 4) Marketing Channels and Brand Awareness
-- a. Which marketing channel can be used to reach more customers
SELECT
	Marketing_channels,
    COUNT(Respondent_ID) AS no_of_respondent_reached
FROM
	fact_survey_responses
GROUP BY
	Marketing_channels
ORDER BY no_of_respondent_reached DESC
LIMIT 1;

-- b. How effective are different marketing strategies and channels in reaching our customers?
SELECT 
    Marketing_channels,
    COUNT(Respondent_ID) AS no_of_respondents,
    AVG(CASE WHEN Tried_before = 'Yes' THEN 1 ELSE 0 END) AS trial_rate,
    AVG(CASE WHEN Heard_before = 'Yes' THEN 1 ELSE 0 END) AS awareness_rate
FROM 
    fact_survey_responses
GROUP BY 
    Marketing_channels
ORDER BY 
    no_of_respondents DESC;

-- 5) Brand Penetration
-- a. What do people think about our brand? (overall rating)
SELECT
	Current_brands,
    Brand_perception,
    COUNT(Brand_perception) AS people_perception_of_brand
FROM
	fact_survey_responses
WHERE
	Current_brands = 'CodeX'
GROUP BY 
	Current_brands, Brand_perception
ORDER BY
	people_perception_of_brand DESC;
    
-- b. Which cities do we need to focus more on?
SELECT
    dr.City_ID,
    dc.City,
    COUNT(f.Respondent_ID) AS total_responses,
    SUM(CASE WHEN f.Brand_perception = 'Negative' THEN 1 ELSE 0 END) AS negative_perception
FROM
    fact_survey_responses f
JOIN
    dim_repondents dr ON f.Respondent_ID = dr.Respondent_ID
JOIN
    dim_cities dc ON dr.City_ID = dc.City_ID
WHERE
    f.Current_brands = 'CodeX'
GROUP BY 
    dr.City_ID, dc.City
ORDER BY
    negative_perception DESC;
    
-- 6) Purchase Behavior
-- a. Where do respondents prefer to purchase energy drinks?
SELECT
	Purchase_location,
    COUNT(Respondent_ID) AS preferred_location
From
	fact_survey_responses
GROUP BY 
	Purchase_location
ORDER BY 
	preferred_location DESC;
    
-- b. What are the typical consumption situations for energy drinks among respondents?
SELECT
	DISTINCT(typical_consumption_situations) consumption_situations
FROM
	fact_survey_responses;
    
-- What factors influence respondents' purchase decisions, such as price range and limited edition packaging?
SELECT 
    Price_range,
    Limited_Edition_Packaging,
    COUNT(Respondent_ID) AS influence_count
FROM 
    fact_survey_responses
GROUP BY 
    Price_range, Limited_Edition_Packaging
ORDER BY 
    influence_count DESC;

-- 7) Product Development
-- Which area of business should we focus more on our product development? (Branding/taste/availability)
SELECT 
    Reasons_for_choosing_brands,
    Improvements_desired,
    COUNT(Respondent_ID) AS count_responses
FROM 
    fact_survey_responses
GROUP BY 
    Reasons_for_choosing_brands, Improvements_desired
ORDER BY 
    count_responses DESC
LIMIT 1;


-- SECONDARY INSIGHT
-- RECOMMENDATIONS
-- 1) What immediate improvements can we bring to the product? The sugar content of the product should be reduced.
SELECT 
    Improvements_desired,
    COUNT(Respondent_ID) AS count_improvements
FROM 
    fact_survey_responses
GROUP BY 
    Improvements_desired
ORDER BY 
    count_improvements DESC
LIMIT 1;

-- 2) What should be the ideal price of our product? The ideal price should be between 50 and 99
SELECT 
	Price_range,
	COUNT(Respondent_ID) AS no_of_respondent_preference
FROM
	fact_survey_responses
GROUP BY
	Price_range
ORDER BY
	no_of_respondent_preference DESC
LIMIT 1;

-- What kind of marketing campaigns, offers, and discounts we can run? 
-- The online ads marketing campaign should be ran, 
-- price-range of 50-99 should be considered and 
-- improvement of the  brand reputation should be considered
SELECT 
    Marketing_channels, 
    Reasons_for_choosing_brands,
    Price_range,
    COUNT(Respondent_ID) AS respondent_count
FROM 
    fact_survey_responses
GROUP BY 
    Marketing_channels, Reasons_for_choosing_brands, Price_range
ORDER BY 
    respondent_count DESC
LIMIT 1;

-- Who can be a brand ambassador, and why?
-- Anyone included in the result of the query below can be an ambassador
-- Why? Because the list include people whose current_brand is CodeX, their perception of CodeX is positive and they daily consume the product
SELECT 
    f.Respondent_ID,
    d.Gender,
    d.Age,
    COUNT(f.Current_brands) AS brand_loyalty
FROM 
    fact_survey_responses AS f
JOIN 
    dim_repondents AS d ON f.Respondent_ID = d.Respondent_ID
WHERE 
    f.Current_brands = 'CodeX'  -- Replace with your specific brand name
    AND f.Brand_perception = 'Positive'
    AND f.Consume_frequency = 'Daily'
GROUP BY 
    f.Respondent_ID, d.Gender, d.Age
ORDER BY 
    brand_loyalty DESC;

-- Who should be our target audience, and why?
-- The target audience should be people within age 19 and 30, reason being that this age group are often involved in draining activities which requires an energy boost
-- So also the research shows ages 19 to 30 as the age bracket with the highest number of CodeX energy drink consumption
SELECT
	d.Age,
    COUNT(f.Respondent_ID) AS consumption_count
FROM
	fact_survey_responses AS f
JOIN
	dim_repondents AS d
ON
	f.Respondent_ID = d.Respondent_ID
GROUP BY
	d.Age
ORDER BY
	consumption_count DESC;
	


 





