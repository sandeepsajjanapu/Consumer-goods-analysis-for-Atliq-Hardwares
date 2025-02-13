#7.Get the complete report of the Gross sales amount for the customer “Atliq
#Exclusive” for each month. This analysis helps to get an idea of low and
#high-performing months and take strategic decisions.
#The final report contains these columns:Month,Year,Grosssales Amount

select concat(monthname(fsm.date),'(',year(fsm.date),')') as Month,fsm.fiscal_year, round(sum(fgp.gross_price*fsm.sold_quantity),2) as Gross_sales_Amount
from dim_customer dc join fact_sales_monthly fsm on dc.customer_code = fsm.customer_code 
join fact_gross_price fgp on fgp.product_code = fsm.product_code 
where dc.customer = 'Atliq Exclusive' 
group by Month,fsm.fiscal_year
order by fsm.fiscal_year;