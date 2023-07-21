-- Examining the dataset to gain insights from data

SELECT COUNT(1)
FROM store_sales
WHERE weekly_sales IS NULL;

-- Which week has the maximum sales?

WITH network_sale AS (
    SELECT 
        YEAR(`date`) AS `year`
        , WEEK(`date`) AS `week`
        , SUM(weekly_sales) as total_sale
    FROM store_sales
    GROUP BY YEAR(`date`),WEEK(`date`)
),
ranked_sale AS (
    SELECT `year`, `week`, total_sale
        ,RANK() OVER (PARTITION BY `year` ORDER BY total_sale DESC) AS `rank`
    FROM network_sale
)
SELECT *
FROM ranked_sale
WHERE `rank` BETWEEN 1 AND 3
ORDER BY 3 DESC
;

-- Which year recorded the highest total sale?

SELECT
    YEAR(`date`) AS `year`
    , SUM(weekly_sales) AS annual_sale
FROM store_sales
GROUP BY YEAR(`date`)
ORDER BY annual_sale DESC
;

-- Checking how many weeks are registered in every year
WITH cte AS (
    SELECT DISTINCT 
        YEAR(`date`) AS `year`
        , WEEK(`date`) AS `week`
    FROM store_sales)
SELECT `year`, COUNT(1) AS weeks_count
FROM cte
GROUP BY `year`
;

/*
2011 stood out as most prosperous year in Walmart's, but in our dataset 2011 is only year for which we have data
for every week.
*/

-- Whitch month in 2011 had the highest sale amount?

SELECT
    MONTH(`date`) AS `month`
    , SUM(weekly_sales) AS monthly_sales
FROM store_sales
WHERE YEAR(`date`) = 2011
GROUP BY MONTH(`date`)
ORDER BY monthly_sales DESC
LIMIT 3
;

/*
Peak of sales appeared on december.
*/

-- Which store had the most sales?

SELECT
    id_store
    , SUM(weekly_sales) AS total_store_sales
FROM store_sales
GROUP BY id_store
ORDER BY total_store_sales DESC
LIMIT 3
;

-- Annualy sale by store
CREATE OR REPLACE VIEW vAnnualySaleByStore AS (
    SELECT 
        id_store
        , SUM(CASE
                WHEN YEAR(`date`) = 2010 THEN weekly_sales ELSE 0 
                END) AS sale_2010
        , SUM(CASE
                WHEN YEAR(`date`) = 2011 THEN weekly_sales ELSE 0 
                END) AS sale_2011
        , SUM(CASE
                WHEN YEAR(`date`) = 2012 THEN weekly_sales ELSE 0 
                END) AS sale_2012
    FROM store_sales
    GROUP BY id_store
) 
;

-- What where the total sales during the holiday and non-holiday weeks?

SELECT
    CASE WHEN holiday_flag = 1 THEN 'holiday' ELSE 'non-holiday' END AS week_type,
    CAST(ROUND(SUM(weekly_sales)/POWER(10,6),0) AS TEXT) AS total_sales
FROM store_sales
GROUP BY holiday_flag
;

-- Which holiday week had the most sales?

SELECT 
    YEAR(`date`) AS `year`
    , WEEK(`date`) AS `week`
    , SUM(weekly_sales) AS holiday_sale
FROM store_sales
WHERE holiday_flag = 1
GROUP BY YEAR(`date`), WEEK(`date`)
ORDER BY holiday_sale DESC
LIMIT 10
;

