#6.Generate a report which contains the top 5 customers who received an
#average high pre_invoice_discount_pct for the fiscal year 2021 and in the
#Indian market. The final output contains these fields,customer_code,customer,average_discount_percentage

select dc.customer_code,dc.customer,round(avg(pre_invoice_discount_pct),4) as average_discount_percentage
from dim_customer dc join fact_pre_invoice_deductions fpid on  dc.customer_code = fpid.customer_code
where fiscal_year = 2021 and market = 'india' group by dc.customer_code,dc.customer
order by average_discount_percentage desc limit 5;