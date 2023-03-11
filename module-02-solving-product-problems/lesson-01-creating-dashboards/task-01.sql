/*
Для каждого дня, представленного в таблицах user_actions и courier_actions, рассчитайте следующие показатели:

Число новых пользователей.
Число новых курьеров.
Общее число пользователей на текущий день.
Общее число курьеров на текущий день.
Колонки с показателями назовите соответственно new_users, new_couriers, total_users, total_couriers. 
Колонку с датами назовите date. Проследите за тем, чтобы показатели были выражены целыми числами. 
Результат должен быть отсортирован по возрастанию даты.

Поля в результирующей таблице: date, new_users, new_couriers, total_users, total_couriers
*/

WITH
    cte_data AS (
        SELECT
            COALESCE(u.date, c.date) as date
            new_users,
            new_couriers
        FROM (
            SELECT
                date,
                COUNT(user_id) AS new_users
            FROM (
                SELECT
                    user_id,
                    DATE_TRUNC('day', MIN(time))::date AS date
                FROM user_actions
                GROUP BY
                    user_id
                ORDER BY
                    user_id
            ) t
            GROUP BY
                date
            ORDER BY
                date
        ) u
        LEFT JOIN (
            SELECT
                date,
                COUNT(courier_id) AS new_couriers
            FROM (
                SELECT
                    courier_id,
                    DATE_TRUNC('day', MIN(time))::date AS date
                FROM courier_actions
                GROUP BY
                    courier_id
                ORDER BY
                    courier_id
            ) t
            GROUP BY
                date
            ORDER BY
                date
        ) AS c
            ON u.date = c.date
    )
SELECT
    date,
    new_users,
    new_couriers,
    SUM(new_users) OVER (ORDER BY date)::INTEGER AS total_users,
    SUM(new_couriers) OVER (ORDER BY date)::INTEGER AS total_couriers
FROM cte_data;