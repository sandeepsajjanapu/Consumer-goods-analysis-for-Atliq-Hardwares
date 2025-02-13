#1.Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region
select * from dim_customer where customer = "Atliq Exclusive" and region = "APAC";

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

#3.provide a report with all the unique product counts for each segment and sort them in 
#descending order of product counts. The final output contains 2 fields,segment,product_count
select segment,count(distinct product_code) as product_count 
from dim_product group by segment order by product_count desc;

#4.Follow-up: Which segment had the most increase in unique products in
#2021 vs 2020? The final output contains these fields,
#segment,product_count_2020,product_count_2021,difference
with cte1 as (select dp.segment as A,count(distinct(fsm.product_code)) as B
              from dim_product dp,fact_sales_monthly fsm where 
              dp.product_code = fsm.product_code
              group by fsm.fiscal_year,dp.segment
              having fsm.fiscal_year = 2020),
	cte2 as (select dp.segment as C,count(distinct(fsm.product_code)) as D
              from dim_product dp,fact_sales_monthly fsm where 
              dp.product_code = fsm.product_code
              group by fsm.fiscal_year,dp.segment
              having fsm.fiscal_year = 2021)
              
select cte1.A as segment,cte1.B as product_count_2020,cte2.D as product_count_2021,(cte2.D-cte1.B) as difference
from cte1,cte2 where cte1.A = cte2.C;


#5.Get the products that have the highest and lowest manufacturing costs.
#The final output should contain these fields,product_code,product,manufacturing_cost

select dp.product_code,product,manufacturing_cost 
from dim_product dp join fact_manufacturing_cost fmc on dp.product_code = fmc.product_code 
where manufacturing_cost in ((select max(manufacturing_cost) from fact_manufacturing_cost),
(select min(manufacturing_cost) from fact_manufacturing_cost)) order by manufacturing_cost desc;

#6.Generate a report which contains the top 5 customers who received an
#average high pre_invoice_discount_pct for the fiscal year 2021 and in the
#Indian market. The final output contains these fields,customer_code,customer,average_discount_percentage

select dc.customer_code,dc.customer,round(avg(pre_invoice_discount_pct),4) as average_discount_percentage
from dim_customer dc join fact_pre_invoice_deductions fpid on  dc.customer_code = fpid.customer_code
where fiscal_year = 2021 and market = 'india' group by dc.customer_code,dc.customer
order by average_discount_percentage desc limit 5;

#7.Get the complete report of the Gross sales amount for the customer “Atliq
#Exclusive” for each month. This analysis helps to get an idea of low and
#high-performing months and take strategic decisions.
#The final report contains these columns:Month,YearGross,sales Amount

select concat(monthname(fsm.date),'(',year(fsm.date),')') as Month,fsm.fiscal_year, round(sum(fgp.gross_price*fsm.sold_quantity),2) as Gross_sales_Amount
from dim_customer dc join fact_sales_monthly fsm on dc.customer_code = fsm.customer_code 
join fact_gross_price fgp on fgp.product_code = fsm.product_code where dc.customer = 'Atliq Exclusive' 
group by Month,fsm.fiscal_year
order by fsm.fiscal_year;

#8.In which quarter of 2020, got the maximum total_sold_quantity? The final
#output contains these fields sorted by the total_sold_quantity,Quarter,total_sold_quantity
select quarter(date) as Quarter,sum(sold_quantity) as total_sold_quantity
from fact_sales_monthly where year(date) = 2020 group by Quarter order by total_sold_quantity desc;

#9. Which channel helped to bring more gross sales in the fiscal year 2021
#and the percentage of contribution? The final output contains these fields,
#channel,gross_sales_mln,percentage
WITH sales_2021 AS (
    SELECT dc.channel, 
           round(sum(gross_price*sold_quantity)/ 1000000,2)  AS gross_sales_mln 
    FROM dim_customer dc 
    JOIN fact_sales_monthly fsm ON dc.customer_code = fsm.customer_code 
    JOIN fact_gross_price fgp ON fgp.product_code = fsm.product_code 
    WHERE fsm.fiscal_year = 2021
    GROUP BY dc.channel
), total_sales AS (
    SELECT SUM(gross_sales_mln) AS total_sales_mln FROM sales_2021
)
SELECT s.channel, 
       concat(s.gross_sales_mln, 'M') AS gross_sales_mln, 
       concat(ROUND((s.gross_sales_mln *100/ t.total_sales_mln), 2),'%') AS percentage
FROM sales_2021 s
JOIN total_sales t
ORDER BY percentage DESC;

#Get the Top 3 products in each division that have a high
#total_sold_quantity in the fiscal_year 2021? The final output contains these
#fields,division,product_code,product,total_sold_quantity,rank_order

with product_sales as (
      select dp.division,fsm.product_code,dp.product,sum(sold_quantity) as total_sold_quantity,
	  rank() over(partition by dp.division order by sum(sold_quantity) desc) as rank_order
	  from dim_product dp join fact_sales_monthly fsm on dp.product_code = fsm.product_code
	  where fiscal_year = 2021 GROUP BY dp.division, fsm.product_code, dp.product)
      
select division,product_code,product,total_sold_quantity,rank_order
from product_sales where rank_order<4;





