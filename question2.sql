-- Which month in 2022 has had the highest revenue?
SELECT month_name,
    SUM(orders.product_quantity * dim_product.sale_price) AS total_revenue
FROM dim_date
    INNER JOIN orders ON orders.order_date = dim_date.date
    INNER JOIN dim_product ON dim_product.product_code = orders.product_code
WHERE dim_date.year = 2022
GROUP BY dim_date.month_name
ORDER BY total_revenue DESC
LIMIT 1