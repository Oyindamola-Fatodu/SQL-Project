-- PROFIT ANALYSIS 
-- 1. Within the space of the last three years, what was the profit worth of the breweries, inclusive of the anglophone and the francophone territories? 
SELECT 
    SUM(PROFIT) AS sum_of_profit
FROM
    international_breweries
GROUP BY
	YEARS;
    
-- Compare the total profit between these two territories in order for the territory manager, Mr. Stone to make a strategic decision that will aid profit maximization in 2020. 
SELECT
	SUM(CASE
			WHEN COUNTRIES IN ('Nigeria', 'Ghana') THEN PROFIT
            ELSE 0
            END) AS anglophone_profit,
	SUM(CASE
			WHEN COUNTRIES IN ('Togo', 'Benin', 'Senegal') THEN PROFIT
            ELSE 0
            END) AS francophone_profit
FROM
	international_breweries;
    
-- What country generated the highest profit in 2019?
SELECT
	COUNTRIES,
    SUM(PROFIT) AS profit_generated
FROM
	international_breweries
WHERE
	YEARS = 2019
GROUP BY
	COUNTRIES
ORDER BY
	profit_generated DESC
LIMIT 1;
    
-- Help him find the year with the highest profit.
SELECT
	YEARS,
    SUM(PROFIT) AS highest_profit
FROM
	international_breweries
GROUP BY 
	YEARS
ORDER BY highest_profit DESC
LIMIT 1;

-- Which month in the three years was the least profit generated?
SELECT 
	MONTHS,
    SUM(PROFIT) AS least_profit
FROM
	international_breweries
GROUP BY
	MONTHS
ORDER BY 
	least_profit ASC
LIMIT 1;

-- What was the minimum profit in the month of December 2018? 
SELECT
	MONTHS,
    MIN(PROFIT)
FROM
	international_breweries
WHERE
	MONTHS = 'December'
    AND YEARS = 2018;

-- Compare the profit for each of the months in 2019 
SELECT
	MONTHS,
    SUM(PROFIT) AS monthly_profit
FROM
	international_breweries
WHERE 
	YEARS = 2019
GROUP BY 
	MONTHS
ORDER BY 
	MONTHS;
 
-- Which particular brand generated the highest profit in Senegal?
SELECT
	BRANDS,
    SUM(PROFIT) AS Highest_profit
FROM
	international_breweries
WHERE
	COUNTRIES = 'Senegal'
GROUP BY
	BRANDS
ORDER BY Highest_profit DESC
LIMIT 1;


-- BRAND ANALYSIS 
-- Within the last two years, the brand manager wants to know the top three brands consumed in the francophone countries 
SELECT
	BRANDS,
    SUM(CASE WHEN COUNTRIES IN ('Togo', 'Benin', 'Senegal') THEN QUANTITY
    ELSE 0 END) AS Quantities_consumed_in_francophone_countries
FROM
	international_breweries
WHERE
	YEARS IN (2018, 2019)
GROUP BY BRANDS
ORDER BY Quantities_consumed_in_francophone_countries DESC
LIMIT 3;

-- Find out the top two choice of consumer brands in Ghana 
SELECT
	BRANDS,
    SUM(QUANTITY) AS Brand_choice
FROM
	international_breweries
WHERE
	COUNTRIES = 'Ghana'
GROUP BY
	BRANDS
ORDER BY 
	Brand_choice DESC
LIMIT 2;

--  Find out the details of beers consumed in the past three years in the most oil reached country in West Africa. 
SELECT
	BRANDS,
    SUM(QUANTITY) AS Quantity
FROM
	international_breweries
WHERE
	BRANDS NOT LIKE '%malt'
    AND COUNTRIES = 'Nigeria'
GROUP BY
	BRANDS
ORDER BY 
	Quantity DESC;
    
-- Favorites malt brand in Anglophone region between 2018 and 2019 
SELECT
	BRANDS,
    SUM(QUANTITY) AS Quantity
FROM
	international_breweries
WHERE
	COUNTRIES IN ('Nigeria', 'Ghana')
	AND BRANDS LIKE '%malt'
    AND YEARS BETWEEN 2018 AND 2019
GROUP BY BRANDS
ORDER BY Quantity DESC
LIMIT 1;

-- Which brands sold the highest in 2019 in Nigeria? 
SELECT
	BRANDS, 
    SUM(QUANTITY) AS Highest_sold
FROM
	international_breweries
WHERE
	COUNTRIES = 'Nigeria'
    AND YEARS = 2019
GROUP BY BRANDS
ORDER BY Highest_sold DESC;

-- Favorites brand in South_South region in Nigeria 
SELECT
	BRANDS,
    SUM(QUANTITY) AS Favorite_brand
FROM
	international_breweries
WHERE
	COUNTRIES = 'Nigeria'
    AND REGION = 'southsouth'
GROUP BY BRANDS
ORDER BY Favorite_brand DESC
LIMIT 1;

-- Bear consumption in Nigeria 
SELECT
    SUM(QUANTITY) AS Total_Beer_consumption
FROM 
	international_breweries
WHERE
	COUNTRIES = 'Nigeria'
    AND BRANDS NOT LIKE '%malt';
    
-- Level of consumption of Budweiser in the regions in Nigeria
SELECT
    REGION,
    SUM(QUANTITY) AS Level_of_consumption
FROM
	international_breweries
WHERE
	BRANDS = 'budweiser'
    AND COUNTRIES = 'Nigeria'
GROUP BY REGION
ORDER BY level_of_consumption DESC;

-- Level of consumption of Budweiser in the regions in Nigeria in 2019 (Decision on Promo)
SELECT
    REGION,
    SUM(QUANTITY) AS Level_of_consumption
FROM
	international_breweries
WHERE
	BRANDS = 'budweiser'
    AND COUNTRIES = 'Nigeria'
    AND YEARS = 2019
GROUP BY REGION
ORDER BY level_of_consumption DESC;

-- COUNTRIES ANALYSIS
-- Country with the highest consumption of beer
SELECT
	COUNTRIES,
    SUM(QUANTITY) AS Highest_beer_consumption
FROM
	international_breweries
WHERE
	BRANDS NOT LIKE '%malt'
GROUP BY
	COUNTRIES
ORDER BY
	Highest_beer_consumption DESC
LIMIT 1;

-- Highest sales personnel of Budweiser in Senegal
SELECT
	SALES_REP,
    SUM(QUANTITY) AS Highest_sales
FROM
	international_breweries
WHERE
	BRANDS = 'budweiser'
    AND COUNTRIES = 'Senegal'
GROUP BY SALES_REP
ORDER BY Highest_sales DESC
LIMIT 1;

-- Country with the highest profit of the fourth quarter in 2019
SELECT
	COUNTRIES,
    SUM(CASE 
			WHEN MONTHS IN ('October', 'November', 'December') THEN PROFIT 
			ELSE 0
		END) AS Highest_fourth_quarter_profit
FROM
	international_breweries
WHERE
	YEARS = 2019
GROUP BY COUNTRIES
ORDER BY Highest_fourth_quarter_profit DESC
LIMIT 1;