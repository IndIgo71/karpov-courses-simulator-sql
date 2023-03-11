/*
Для каждого дня рассчитайте следующие показатели:

Долю пользователей, сделавших в этот день всего один заказ, в общем количестве платящих пользователей.
Долю пользователей, сделавших в этот день несколько заказов, в общем количестве платящих пользователей.
Колонки с показателями назовите соответственно single_order_users_share, several_orders_users_share. 
Колонку с датами назовите date. Все показатели с долями необходимо выразить в процентах. 
При расчёте долей округляйте значения до двух знаков после запятой.

Результат должен быть отсортирован по возрастанию даты.

Поля в результирующей таблице: date, single_order_users_share, several_orders_users_share
*/

WITH
    cte_user_orders AS (
        SELECT
            time::date AS date,
            user_id,
            COUNT(DISTINCT order_id) AS order_cnt
        FROM user_actions
        WHERE
            action = 'create_order'
            AND order_id NOT IN (
            SELECT order_id
            FROM user_actions
            WHERE action = 'cancel_order'
        )
        GROUP BY
            date,
            user_id
    ),
    cte_orders_cnt_by_user AS (
        SELECT
            date,
            COUNT(DISTINCT user_id) FILTER (WHERE order_cnt = 1) AS single_order_users_cnt,
            COUNT(DISTINCT user_id) FILTER (WHERE order_cnt > 1) AS several_orders_users_cnt,
            COUNT(DISTINCT user_id) AS total
        FROM cte_user_orders
        GROUP BY
            date
    )
SELECT
    date,
    ROUND(single_order_users_cnt::DECIMAL / total * 100, 2) AS single_order_users_share,
    ROUND(several_orders_users_cnt::DECIMAL / total * 100, 2) AS several_orders_users_share
FROM cte_orders_cnt_by_user t
ORDER BY
    date;