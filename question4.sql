-- Create a view where the rows are the store types and the columns are the total sales, 
-- percentage of total sales and the count of orders
SELECT store_type,
    ROUND(
        SUM(dim_product.sale_price * orders.product_quantity)
    ) AS total_sales,
    ROUND(
        (
            SUM(dim_product.sale_price * orders.product_quantity) / (
                SELECT SUM(dim_product.sale_price * orders.product_quantity)
                FROM orders
                    INNER JOIN dim_product ON dim_product.product_code = orders.product_code
            )
        ) * 100
    ) AS percentage_of_sale,
    COUNT(orders.order_date) AS total_orders_per_store
FROM dim_store
    INNER JOIN orders ON orders.store_code = dim_store.store_code
    INNER JOIN dim_product ON dim_product.product_code = orders.product_code
GROUP BY store_type
ORDER BY total_sales DESC;