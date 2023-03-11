/*
Для каждого дня, представленного в таблицах user_actions и courier_actions, рассчитайте следующие показатели:

Число платящих пользователей.
Число активных курьеров.
Долю платящих пользователей в общем числе пользователей на текущий день.
Долю активных курьеров в общем числе курьеров на текущий день.
Колонки с показателями назовите соответственно paying_users, active_couriers, paying_users_share, active_couriers_share. 
Колонку с датами назовите date. Проследите за тем, чтобы абсолютные показатели были выражены целыми числами. Все показатели долей необходимо выразить в процентах. При их расчёте округляйте значения до двух знаков после запятой.

Результат должен быть отсортирован по возрастанию даты. 

Поля в результирующей таблице: date, paying_users, active_couriers, paying_users_share, active_couriers_share
*/

WITH
    cte_user_orders AS (
        SELECT
            COUNT(DISTINCT user_id) AS paying_users,
            time::date AS date
        FROM user_actions
        WHERE
            action = 'create_order'
            AND order_id NOT IN (
                SELECT order_id
                FROM user_actions
                WHERE action = 'cancel_order'
            )
        GROUP BY
            date
    ),
    cte_courier_orders AS (
        SELECT
            COUNT(DISTINCT courier_id) AS active_couriers,
            time::date AS date
        FROM courier_actions
        WHERE
            action != 'cancel_order'
            AND order_id NOT IN (
                SELECT order_id
                FROM user_actions
                WHERE action = 'cancel_order'
            )
        GROUP BY
            date
    ),
    cte_totals AS (
        SELECT
            COALESCE(u.date, c.date) AS date,
            SUM(u.new_users) OVER (ORDER BY u.date) AS total_users,
            SUM(c.new_couriers) OVER (ORDER BY c.date) AS total_couriers
        FROM (
            SELECT
                date,
                COUNT(user_id) AS new_users
            FROM (
                SELECT user_id, MIN(time::date) AS date
                FROM user_actions
                GROUP BY user_id
            ) t
            GROUP BY
                date
        ) u
        LEFT JOIN (
            SELECT
                date,
                COUNT(courier_id) AS new_couriers
            FROM (
                SELECT courier_id, MIN(time::date) AS date
                FROM courier_actions
                GROUP BY courier_id
            ) t
            GROUP BY
                date
        ) AS c
            USING (date)
    )
SELECT
    COALESCE(uo.date, co.date, tt.date) AS date,
    uo.paying_users,
    co.active_couriers,
    ROUND(uo.paying_users::DECIMAL / tt.total_users * 100, 2) AS paying_users_share,
    ROUND(co.active_couriers::DECIMAL / tt.total_couriers * 100, 2) AS active_couriers_share
FROM cte_user_orders uo
LEFT JOIN cte_courier_orders co
    ON co.date = uo.date
LEFT JOIN cte_totals tt
    ON tt.date = uo.date
ORDER BY
    date;