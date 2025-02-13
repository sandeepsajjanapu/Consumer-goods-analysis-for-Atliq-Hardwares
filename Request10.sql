#10.Get the Top 3 products in each division that have a high
#total_sold_quantity in the fiscal_year 2021? The final output contains these
#fields,division,product_code,product,total_sold_quantity,rank_order

with product_sales as (
      select dp.division,fsm.product_code,dp.product,sum(sold_quantity) as total_sold_quantity,
	  rank() over(partition by dp.division order by sum(sold_quantity) desc) as rank_order
	  from dim_product dp join fact_sales_monthly fsm on dp.product_code = fsm.product_code
	  where fiscal_year = 2021 GROUP BY dp.division, fsm.product_code, dp.product)
      
select division,product_code,product,total_sold_quantity,rank_order
from product_sales where rank_order<4;