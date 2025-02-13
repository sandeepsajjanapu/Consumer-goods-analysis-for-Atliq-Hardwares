#2. What is the percentage of unique product increase in 2021 vs. 2020? The 
#final output contains these fields,unique_products_2020,unique_products_2021,percentage_chg

with products_count as (
	 select cost_year,count(distinct dp.product_code)  as unique_products
     from dim_product dp join fact_manufacturing_cost fmc on dp.product_code = fmc.product_code group by cost_year
)

select up_2020.unique_products as unique_products_2020, up_2021.unique_products as unique_products_2021, 
      round((up_2021.unique_products-up_2020.unique_products)*100/up_2020.unique_products,2) as percentage_chg
from 
(select unique_products from products_count where cost_year = 2020) up_2020,
(select unique_products from products_count where cost_year = 2021) up_2021;