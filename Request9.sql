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