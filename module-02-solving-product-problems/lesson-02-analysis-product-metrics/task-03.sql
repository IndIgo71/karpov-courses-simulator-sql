/*
для каждого дня рассчитайте следующие показатели:

Накопленную выручку на пользователя (Running ARPU).
Накопленную выручку на платящего пользователя (Running ARPPU).
Накопленную выручку с заказа, или средний чек (Running AOV).
Колонки с показателями назовите соответственно running_arpu, running_arppu, running_aov. Колонку с датами назовите date. 

При расчёте всех показателей округляйте значения до двух знаков после запятой.

Результат должен быть отсортирован по возрастанию даты. 

Поля в результирующей таблице: date, running_arpu, running_arppu, running_aov
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
            COUNT(DISTINCT o.order_id) AS order_cnt,
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
    cte_users AS (
        SELECT
            time::date AS date,
            COUNT(DISTINCT user_id) FILTER (WHERE time::date = first_date) AS new_users_cnt,
            COUNT(DISTINCT user_id) FILTER (WHERE time::date = first_order) AS new_paying_users_cnt
        FROM (
            SELECT
                user_id,
                MIN(time::date) AS first_date,
                MIN(time::date) FILTER (
                    WHERE order_id NOT IN (select order_id from cte_canceled_orders)
                ) AS first_order
            FROM user_actions
            GROUP BY
                user_id
        ) AS t
        LEFT JOIN user_actions ua
            ON t.user_id = ua.user_id
        GROUP BY
            date
    )
SELECT
    r.date,
    ROUND(SUM(r.revenue) OVER (ORDER BY r.date)::DECIMAL / SUM(u.new_users_cnt) OVER (ORDER BY r.date), 2) AS running_arpu,
    ROUND(SUM(r.revenue) OVER (ORDER BY r.date)::DECIMAL / SUM(u.new_paying_users_cnt) OVER (ORDER BY r.date), 2) AS running_arppu,
    ROUND(SUM(r.revenue) OVER (ORDER BY r.date)::DECIMAL / SUM(r.order_cnt) OVER (ORDER BY r.date), 2) AS running_aov
FROM cte_revenue_by_date r
LEFT JOIN cte_users u
    ON r.date = u.date
ORDER BY
    r.date;