/*
Part 1 - Data Cleaning
Dataset: https://www.kaggle.com/datasets/new-york-city/nyc-property-sales
*/

#data column names and value types
DESCRIBE nycsales;

#table snippet
SELECT *
FROM nycsales;

#standardize date
SELECT DATE_FORMAT(sale_date, '%Y-%m-%d') AS standardized_date
FROM nycsales;


/*
Part 2 - Data Exploration - Unit Distribution Analysis
*/

#residential and commercial unit count by borough
SELECT borough, building_type,
	SUM(residential_unit_count) AS total_residential_units,
    SUM(commercial_unit_count) AS total_commercial_units
FROM nycsales
GROUP BY borough, building_type
ORDER BY total_residential_units, total_commercial_units
DESC;

#total units by building type
SELECT building_type, 
	SUM(residential_unit_count) AS total_residential_units,
    SUM(commercial_unit_count) AS total_commercial_units
FROM nycsales
GROUP BY building_type
ORDER BY building_type, total_residential_units, total_commercial_units
DESC;


/*
Part 3 - Data Exploration - Unit Price Analysis
*/

#calculate unit price per sq ft
SELECT neighborhood, building_type,
	AVG(sale_price/gross_sq_ft) AS cost_per_sq_ft
FROM nycsales
GROUP BY neighborhood, building_type
ORDER BY cost_per_sq_ft
DESC;


/*
compare top 5 most expensive neighborhoods from highest to lowest: kensington, fort greene, clinton, civic center, midtown west
*/

#kensington
SELECT neighborhood, building_type,
		AVG(sale_price/gross_sq_ft) AS cost_per_sq_ft
FROM nycsales
WHERE neighborhood = 'kensington'
GROUP BY building_type
ORDER BY cost_per_sq_ft
DESC;

#fort greene
SELECT neighborhood, building_type,
		AVG(sale_price/gross_sq_ft) AS cost_per_sq_ft
FROM nycsales
WHERE neighborhood = 'fort greene'
GROUP BY building_type
ORDER BY cost_per_sq_ft
DESC;

#clinton
SELECT neighborhood, building_type,
		AVG(sale_price/gross_sq_ft) AS cost_per_sq_ft
FROM nycsales
WHERE neighborhood = 'clinton'
GROUP BY building_type
ORDER BY cost_per_sq_ft
DESC;

#civic center
SELECT neighborhood, building_type,
		AVG(sale_price/gross_sq_ft) AS cost_per_sq_ft
FROM nycsales
WHERE neighborhood = 'civic center'
GROUP BY building_type
ORDER BY cost_per_sq_ft
DESC;

#midtown west
SELECT neighborhood, building_type,
		AVG(sale_price/gross_sq_ft) AS cost_per_sq_ft
FROM nycsales
WHERE neighborhood = 'midtown west'
GROUP BY building_type
ORDER BY cost_per_sq_ft
DESC;