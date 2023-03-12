/*
Для каждого дня рассчитайте следующие показатели:

Выручку на пользователя (ARPU) за текущий день.
Выручку на платящего пользователя (ARPPU) за текущий день.
Выручку с заказа, или средний чек (AOV) за текущий день.

При расчёте всех показателей округляйте значения до двух знаков после запятой.

Результат должен быть отсортирован по возрастанию даты. 

Поля в результирующей таблице: date, arpu, arppu, aov
*/

WITH
    cte_canceled_orders AS (
        SELECT order_id
        FROM user_actions
        WHERE action = 'cancel_order'
    ),
    cte_revenue_by_date AS (
        SELECT DISTINCT
            o.creation_time::date AS date,
            SUM(p.price) AS revenue
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
            date
    ),
    cte_users_and_orders AS (
        SELECT
            time::date AS date,
            COUNT(DISTINCT user_id) AS total_users,
            COUNT(DISTINCT user_id) FILTER (
                WHERE order_id NOT IN (SELECT order_id FROM cte_canceled_orders)
            ) AS paying_users,
            COUNT(order_id) FILTER (
                WHERE order_id NOT IN (SELECT order_id FROM cte_canceled_orders)
            ) AS orders
        FROM user_actions
        GROUP BY
            date
    )
SELECT
    r.date,
    ROUND(r.revenue::DECIMAL / uo.total_users, 2) AS arpu,
    ROUND(r.revenue::DECIMAL / uo.paying_users, 2) AS arppu,
    ROUND(r.revenue::DECIMAL / uo.orders, 2) AS aov
FROM cte_revenue_by_date r
LEFT JOIN cte_users_and_orders uo
    ON r.date = uo.date
ORDER BY
    r.date;