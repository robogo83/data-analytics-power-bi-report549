-- Which German store type had the highest revenue for 2022?
SELECT store_type,
    SUM(orders.product_quantity * dim_product.sale_price) AS total_revenue
FROM dim_store
    INNER JOIN orders ON orders.store_code = dim_store.store_code
    INNER JOIN dim_product ON dim_product.product_code = orders.product_code
    INNER JOIN dim_date ON dim_date.date = orders.order_date
WHERE dim_date.year = 2022
    AND dim_store.country = 'Germany'
GROUP BY dim_store.store_type
ORDER BY total_revenue DESC
LIMIT 1