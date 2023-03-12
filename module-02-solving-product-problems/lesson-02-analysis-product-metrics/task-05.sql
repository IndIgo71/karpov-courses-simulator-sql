/*
Для каждого дня рассчитайте следующие показатели:

Выручку, полученную в этот день.
Выручку с заказов новых пользователей, полученную в этот день.
Долю выручки с заказов новых пользователей в общей выручке, полученной за этот день.
Долю выручки с заказов остальных пользователей в общей выручке, полученной за этот день.
Колонки с показателями назовите соответственно revenue, new_users_revenue, new_users_revenue_share, old_users_revenue_share. 
Колонку с датами назовите date. 

Все показатели долей необходимо выразить в процентах. При их расчёте округляйте значения до двух знаков после запятой.
Результат должен быть отсортирован по возрастанию даты.

Поля в результирующей таблице: date, revenue, new_users_revenue, new_users_revenue_share, old_users_revenue_share
*/

WITH
    cte_canceled_orders AS (
        SELECT order_id
        FROM user_actions
        WHERE action = 'cancel_order'
    ),
    cte_order_products AS (
        SELECT
            o.creation_time::date AS date,
            o.order_id,
            p.price
        FROM orders o
        CROSS JOIN UNNEST(product_ids) ps(product_id)
        INNER JOIN products p
            ON p.product_id = ps.product_id
        WHERE
            o.order_id NOT IN (
                SELECT order_id
                FROM cte_canceled_orders
            )
    ),
    cte_first_order AS (
        SELECT
            min_date,
            order_id
        FROM (
            SELECT
                time::date AS date,
                MIN(time::date) OVER (PARTITION BY user_id) AS min_date,
                order_id
            FROM user_actions
        ) t
        WHERE
            order_id NOT IN (
                SELECT order_id
                FROM cte_canceled_orders
            )
            AND date = min_date
        GROUP BY
            min_date,
            order_id
    ),
    cte_new_users_revenue AS (
        SELECT
            min_date AS date,
            SUM(price) AS new_users_revenue
        FROM (
            SELECT
                fo.min_date,
                fo.order_id,
                op.price
            FROM cte_first_order fo
            left join cte_order_products op
                ON op.order_id = fo.order_id
        ) w1
        GROUP BY
            min_date
    ),
    cte_revenue AS (
        SELECT DISTINCT
            date,
            SUM(price) AS revenue
        FROM cte_order_products
        GROUP BY
            date
    )
SELECT
    r.date,
    revenue,
    nur.new_users_revenue,
    ROUND(nur.new_users_revenue::DECIMAL / revenue * 100, 2) AS new_users_revenue_share,
    ROUND((revenue - nur.new_users_revenue)::DECIMAL / revenue * 100, 2) AS old_users_revenue_share
FROM cte_new_users_revenue nur
LEFT JOIN cte_revenue r
    ON nur.date = r.date;