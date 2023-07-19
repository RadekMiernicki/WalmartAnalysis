import json
from local_connector import Client
import os
import csv

with open ('./WalmartAnalysis/data/walmart_data.csv','r') as f:
    reader = csv.reader(f, delimiter=',', quotechar='|')
    next(reader)
    data: str = ''
    for row in reader:
        date=str(row.pop(1))
        date = ", STR_TO_DATE('"+date+"','%d-%m-%Y')),"
        str_row = "(" + ", ".join(str(v) for v in row)+ date
        data += str_row


data = data[:-1]

with open ('./WalmartAnalysis/WalmartSQLAnalysis/.config.json', 'r') as f:
    configs = json.load(f)
    config = configs.get('Walmart')


walmart = Client(config)

sql_statement = """
INSERT INTO store_sales 
    (id_store, weekly_sales, holiday_flag, temperature, fuel_price, cpi, unemployment_rate, `date`)
VALUES
"""
sql_statement += data
sql_statement += ";"

walmart.statement(sql_statement)


