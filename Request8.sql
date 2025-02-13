#8.In which quarter of 2020, got the maximum total_sold_quantity? The final
#output contains these fields sorted by the total_sold_quantity,Quarter,total_sold_quantity
select quarter(date) as Quarter,sum(sold_quantity) as total_sold_quantity
from fact_sales_monthly where year(date) = 2020 group by Quarter order by total_sold_quantity desc;