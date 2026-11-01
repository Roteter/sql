WITH monthly AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp)::date AS month,
        COUNT(DISTINCT o.order_id)                            AS orders,
        SUM(oi.price)                                         AS revenue
    FROM olist_orders_dataset o
    JOIN olist_order_items_dataset oi
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
)
SELECT
    month,
    orders,
    ROUND(revenue, 2)               AS revenue,
    ROUND(revenue / orders, 2)      AS avg_check,
    ROUND(
        100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
        / NULLIF(LAG(revenue) OVER (ORDER BY month), 0)
    , 1)                            AS revenue_mom_pct
FROM monthly
WHERE month BETWEEN DATE '2017-01-01' AND DATE '2018-08-01'
ORDER BY month;
