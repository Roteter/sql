-- 1. Дубли заказов (ожидаем 0)
SELECT COUNT(*) - COUNT(DISTINCT order_id) AS duplicate_orders
FROM olist_orders_dataset;

-- 2. Заказы без позиций
SELECT o.order_status, COUNT(*) AS orders_without_items
FROM olist_orders_dataset o
LEFT JOIN olist_order_items_dataset oi ON oi.order_id = o.order_id
WHERE oi.order_id IS NULL
GROUP BY 1
ORDER BY 2 DESC;

-- 3. Доставленные заказы без даты доставки
SELECT COUNT(*) AS delivered_without_date
FROM olist_orders_dataset
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;

-- 4. Расхождение суммы позиций (цена + доставка) и платежей
WITH items AS (
    SELECT order_id, SUM(price + freight_value) AS items_total
    FROM olist_order_items_dataset
    GROUP BY 1
),
pay AS (
    SELECT order_id, SUM(payment_value) AS pay_total
    FROM olist_order_payments_dataset
    GROUP BY 1
)
SELECT
    COUNT(*) AS orders_compared,
    COUNT(*) FILTER (WHERE ABS(i.items_total - p.pay_total) > 1) AS mismatched
FROM items i
JOIN pay p USING (order_id);

-- 5. Дубли review_id и заказы с несколькими отзывами
SELECT COUNT(*) - COUNT(DISTINCT review_id) AS duplicate_review_ids
FROM olist_order_reviews_dataset;

SELECT COUNT(*) AS orders_with_multiple_reviews
FROM (
    SELECT order_id
    FROM olist_order_reviews_dataset
    GROUP BY 1
    HAVING COUNT(*) > 1
) t;

-- 6. Товары без категории
SELECT COUNT(*) AS products_without_category
FROM olist_products_dataset
WHERE product_category_name IS NULL;
