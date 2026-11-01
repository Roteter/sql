SELECT order_status, COUNT(*), ROUND(
    100.0 * (revenue - LAG(revenue, 12) OVER (ORDER BY month))
    / NULLIF(LAG(revenue, 12) OVER (ORDER BY month), 0)
, 1) AS revenue_yoy_pct

FROM olist_orders_dataset
WHERE order_purchase_timestamp >= '2018-07-01'
GROUP BY 1
ORDER BY 2 DESC;
