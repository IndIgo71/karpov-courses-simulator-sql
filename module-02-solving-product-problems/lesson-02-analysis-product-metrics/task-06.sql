/*
Для каждого товара за весь период времени рассчитайте следующие показатели:

Суммарную выручку, полученную от продажи этого товара за весь период.
Долю выручки от продажи этого товара в общей выручке, полученной за весь период.
Колонки с показателями назовите соответственно revenue и share_in_revenue. Колонку с наименованиями товаров назовите product_name.
Долю выручки с каждого товара необходимо выразить в процентах. При её расчёте округляйте значения до двух знаков после запятой.
Товары, округлённая доля которых в выручке составляет менее 0.5%, объедините в общую группу с названием «ДРУГОЕ» (без кавычек).
Результат должен быть отсортирован по убыванию выручки от продажи товара.

Поля в результирующей таблице: product_name, revenue, share_in_revenue
*/

WITH
    cte_canceled_orders AS (
        SELECT order_id
        FROM user_actions
        WHERE action = 'cancel_order'
    ),
    cte_product_cost AS (
        SELECT
            p.name AS product_name,
            SUM(p.price) AS product_price_sum
        FROM orders o
        CROSS JOIN UNNEST(product_ids) ps(product_id)
        INNER JOIN products p
            ON p.product_id = ps.product_id
        WHERE
            o.order_id NOT IN (
                SELECT order_id
                FROM cte_canceled_orders
            )
        GROUP BY
            p.name
    ),
    cte_product_revenue AS (
        SELECT
            product_name,
            SUM(product_price_sum) AS product_revenue
        FROM cte_product_cost
        GROUP BY product_name
    ),
    cte_revenue_add_share AS (
        SELECT
            product_name,
            product_revenue,
            ROUND(product_revenue / SUM(product_revenue) OVER () * 100, 2) AS product_share_in_revenue
        FROM cte_product_revenue
    ),
    cte_revenue_format AS (
        SELECT
            CASE
                WHEN product_share_in_revenue <= 0.5
                    THEN 'ДРУГОЕ'
                ELSE product_name
            END AS product_name,
            product_revenue,
            product_share_in_revenue
        FROM cte_revenue_add_share
    )
SELECT
    product_name,
    SUM(product_revenue) AS revenue,
    SUM(product_share_in_revenue) AS share_in_revenue
FROM cte_revenue_format
GROUP BY
    product_name
ORDER BY
    revenue DESC;