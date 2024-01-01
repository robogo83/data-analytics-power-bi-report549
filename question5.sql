-- Which product category generated the most profit for the "Wiltshire, UK" region in 2021?
SELECT category,
    ROUND(
        SUM(
            (dim_product.sale_price - dim_product.cost_price) * orders.product_quantity
        )
    ) as total_profit
FROM dim_product
    INNER JOIN orders ON orders.product_code = dim_product.product_code
    INNER JOIN dim_store ON dim_store.store_code = orders.store_code
WHERE dim_store.full_region = 'Wiltshire, UK'
GROUP BY category
ORDER BY total_profit DESC
LIMIT 1