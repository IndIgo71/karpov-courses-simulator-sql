/*
Посчитайте количество уникальных клиентов в таблице user_actions, сделавших за последнюю неделю хотя бы один заказ. Полученную колонку со значением назовите users_count. В качестве текущей даты, от которой откладывать неделю, используйте последнюю дату в той же таблице user_actions.

Поле в результирующей таблице: users_count.
*/

WITH
    cte_users_make_order AS (
        SELECT
            user_id
        FROM user_actions
        WHERE
            action = 'create_order'
            AND time >= (
            SELECT MAX(time)
            FROM user_actions
        ) - INTERVAL '1 week'
        GROUP BY
            user_id
        HAVING
            COUNT(order_id) >= 1
    )
SELECT
    COUNT(DISTINCT user_id) AS users_count
FROM cte_users_make_order;