#5.Get the products that have the highest and lowest manufacturing costs.
#The final output should contain these fields,product_code,product,manufacturing_cost

select dp.product_code,product,manufacturing_cost 
from dim_product dp join fact_manufacturing_cost fmc on dp.product_code = fmc.product_code 
where manufacturing_cost in ((select max(manufacturing_cost) from fact_manufacturing_cost),
(select min(manufacturing_cost) from fact_manufacturing_cost)) order by manufacturing_cost desc;