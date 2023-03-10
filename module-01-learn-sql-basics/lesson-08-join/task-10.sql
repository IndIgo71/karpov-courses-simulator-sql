/*
Снова объедините таблицы user_actions и orders, но теперь оставьте только уникальные неотменённые заказы (мы делали похожий запрос на прошлом уроке). Остальные условия задачи те же: вывести id пользователей и заказов, а также список товаров в заказе. Отсортируйте таблицу по id пользователя по возрастанию, затем по id заказа — тоже по возрастанию.

Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.

Поля в результирующей таблице: user_id, order_id, product_ids.
*/

WITH
    cte_user_action AS (
        SELECT *
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
    ua.order_id,
    o.product_ids
FROM cte_user_action ua
INNER JOIN orders o
    ON ua.order_id = o.order_id
ORDER BY
    ua.user_id,
    ua.order_id
LIMIT 1000;