-- create table on Walmart db
DROP TABLE IF EXISTS store_sales;

CREATE TABLE IF NOT EXISTS store_sales (
    id_store INT NOT NULL,
    `date` DATE,
    weekly_sales DECIMAL(12,2),
    holiday_flag INT,
    temperature DECIMAL(5,2),
    fuel_price DECIMAL(4,2),
    cpi FLOAT,
    unemployment_rate DECIMAL(6,3)
);

LOAD DATA INFILE './data/walmart_data.csv' 
INTO TABLE store_sales 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Store,Date,Weekly_Sales,Holiday_Flag,Temperature,Fuel_Price,CPI,Unemployment