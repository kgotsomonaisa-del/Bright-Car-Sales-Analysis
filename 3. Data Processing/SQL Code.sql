--Bright Motors car sales code
-----------------------------------------------------------------------------------------------
--Retrieving all columns from the table, limiting to 10 rows
select * from `workspace`.`brightmotors`.`car_sales` limit 10;
-----------------------------------------------------------------------------------------------
--Retrieving the data capture start and end date
select min(sale_date) as start_date, max(sale_date) as end_date
from `workspace`.brightmotors.car_sales;
--The data was captured from 2014-01-01 to 2015-07-21
-----------------------------------------------------------------------------------------------
--Counting the number of days between the data capture start date and end date
select datediff(max(sale_date), min(sale_date)) as sales_period
from `workspace`.`brightmotors`.car_sales;
--The data was captured for a period of 566 days
-----------------------------------------------------------------------------------------------
--Retrieving the number of unique vehicles sold
select count(distinct(vin)) as unique_vehicles
from `workspace`.brightmotors.car_sales;
--there are 500 unique vehicles
-----------------------------------------------------------------------------------------------
--KPI snapshot
SELECT
  COUNT(*) AS transactions,
  ROUND(SUM(total_revenue), 2) AS total_revenue,
  ROUND(AVG(sellingprice), 2) AS avg_selling_price,
  ROUND(PERCENTILE(sellingprice, 0.5), 2) AS median_selling_price,
  ROUND(AVG(profit_margin_proxy_pct), 2) AS avg_margin_proxy_pct,
  COUNT(DISTINCT state) AS distinct_states,
  COUNT(DISTINCT make) AS distinct_makes,
  COUNT(DISTINCT model) AS distinct_models
FROM workspace.brightmotors.car_sales;
-----------------------------------------------------------------------------------------------
-- Revenue by make and model
SELECT
  make,
  model,
  SUM(units_sold) AS units_sold,
  ROUND(SUM(total_revenue), 2) AS total_revenue,
  ROUND(AVG(sellingprice), 2) AS avg_selling_price,
  ROUND(AVG(profit_margin_proxy_pct), 2) AS avg_margin_proxy_pct
FROM workspace.brightmotors.car_sales
GROUP BY make, model
ORDER BY total_revenue DESC
LIMIT 25;
-----------------------------------------------------------------------------------------------
-- Regional performance
SELECT
  sales_region,
  state,
  SUM(units_sold) AS units_sold,
  ROUND(SUM(total_revenue), 2) AS total_revenue,
  ROUND(AVG(sellingprice), 2) AS avg_selling_price,
  ROUND(AVG(profit_margin_proxy_pct), 2) AS avg_margin_proxy_pct
FROM workspace.brightmotors.car_sales
GROUP BY sales_region, state
ORDER BY total_revenue DESC;
-----------------------------------------------------------------------------------------------
-- Sales distribution by vehicle year and body type
SELECT
  year as vehicle_year,
  body,
  SUM(units_sold) AS units_sold,
  ROUND(SUM(total_revenue), 2) AS total_revenue,
  ROUND(AVG(sellingprice), 2) AS avg_selling_price
FROM workspace.brightmotors.car_sales
GROUP BY vehicle_year, body
ORDER BY vehicle_year, units_sold DESC;
-----------------------------------------------------------------------------------------------
--Average selling price trend over time
SELECT
  sale_month,
  sale_month_name,
  SUM(units_sold) AS units_sold,
  ROUND(SUM(total_revenue), 2) AS total_revenue,
  ROUND(AVG(sellingprice), 2) AS avg_selling_price,
  ROUND(AVG(odometer), 2) AS avg_odometer
FROM workspace.brightmotors.car_sales
GROUP BY sale_month, sale_month_name
ORDER BY sale_month;
-----------------------------------------------------------------------------------------------
--Preference analysis using the closest available source fields
SELECT
  body,
  transmission,
  SUM(units_sold) AS units_sold,
  ROUND(SUM(total_revenue), 2) AS total_revenue,
  ROUND(AVG(sellingprice), 2) AS avg_selling_price
FROM workspace.brightmotors.car_sales
GROUP BY body, transmission
ORDER BY units_sold DESC, total_revenue DESC;
-----------------------------------------------------------------------------------------------
--Relationship between price, mileage, and model year
SELECT
  year as vehicle_year,
  odometer_band,
  COUNT(*) AS vehicles,
  ROUND(AVG(sellingprice), 2) AS avg_selling_price,
  ROUND(AVG(odometer), 2) AS avg_odometer,
  ROUND(AVG(condition), 2) AS avg_condition
FROM workspace.brightmotors.car_sales
GROUP BY year, odometer_band
ORDER BY vehicle_year DESC, odometer_band;
-----------------------------------------------------------------------------------------------
--Top sellers
SELECT
  seller,
  SUM(units_sold) AS units_sold,
  ROUND(SUM(total_revenue), 2) AS total_revenue,
  ROUND(AVG(sellingprice), 2) AS avg_selling_price
FROM workspace.brightmotors.car_sales
GROUP BY seller
ORDER BY total_revenue DESC
LIMIT 20;
-----------------------------------------------------------------------------------------------
--Single concentrated query
SELECT 
  sales_region,
  state_name,
  year as vehicle_year,
  body,
  sale_month,
  sale_month_name,
  transmission,
  odometer_band,
  make,
  model,
  COUNT(*) AS transactions,
  ROUND(SUM(total_revenue), 2) AS total_revenue,
  ROUND(AVG(sellingprice), 2) AS avg_selling_price,
  ROUND(PERCENTILE(sellingprice, 0.5), 2) AS median_selling_price,
  ROUND(AVG(profit_margin_proxy_pct), 2) AS avg_margin_proxy_pct,
  COUNT(DISTINCT make) AS distinct_makes,
  COUNT(DISTINCT model) AS distinct_models,
  COUNT(DISTINCT state) AS distinct_states,
  SUM(units_sold) AS units_sold,
  COUNT(*) AS vehicles,
  ROUND(AVG(odometer), 2) AS avg_odometer,
  ROUND(AVG(condition), 2) AS avg_condition,
  ROUND(SUM(price_gap_to_mmr), 2) AS total_price_gap_to_mmr
FROM workspace.brightmotors.car_sales
GROUP BY sale_month, 
        sale_month_name, 
        make, 
        sales_region, 
        state_name, 
        model, 
        year, 
        odometer_band,
        body, 
        transmission
ORDER BY total_revenue DESC, 
        year DESC, 
        sale_month, 
        odometer_band;

















