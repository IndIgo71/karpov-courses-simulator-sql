/*
Используя запрос из предыдущего задания, посчитайте, сколько в среднем товаров заказывает каждый пользователь. Выведите id пользователя и среднее количество товаров в заказе. Среднее значение округлите до двух знаков после запятой. Колонку посчитанными значениями назовите avg_order_size. Результат выполнения запроса отсортируйте по возрастанию id пользователя. 

Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.

Поля в результирующей таблице: user_id, avg_order_size.
*/

WITH
    cte_user_action AS (
        SELECT
            user_id,
            order_id
        FROM user_actions
        WHERE
            action = 'create_order'
            AND order_id NOT IN (
            SELECT order_id
            FROM user_actions
            WHERE action = 'cancel_order'
        )
    )
SELECT
    ua.user_id,
    ROUND(AVG(ARRAY_LENGTH(o.product_ids, 1)), 2) AS avg_order_size
FROM cte_user_action ua
INNER JOIN orders o
    ON ua.order_id = o.order_id
GROUP BY
    ua.user_id
ORDER BY
    ua.user_id
LIMIT 1000;