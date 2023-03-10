/*
Объедините запрос из предыдущего задания с частью запроса, который вы составили в задаче 11, то есть объедините запрос со стоимостью заказов с запросом, в котором вы считали размер каждого заказа из таблицы user_actions.

На основе объединённой таблицы для каждого пользователя рассчитайте следующие показатели:
- общее число заказов — колонку назовите orders_count
- среднее количество товаров в заказе — avg_order_size
- суммарную стоимость всех покупок — sum_order_value
- среднюю стоимость заказа — avg_order_value
- минимальную стоимость заказа — min_order_value
- максимальную стоимость заказа — max_order_value
- Полученный результат отсортируйте по возрастанию id пользователя.

Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.

Помните, что в расчётах мы по-прежнему учитываем только неотменённые заказы. При расчёте средних значений, округляйте их до двух знаков после запятой.

Поля в результирующей таблице: 
user_id, orders_count, avg_order_size, sum_order_value, avg_order_value, min_order_value, max_order_value.
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
    ),
    cte_orders_content AS (
        SELECT order_id, ARRAY_LENGTH(product_ids, 1) AS order_size, product_ids FROM orders
    ),
    cte_order_sum AS (
        SELECT
            oc.order_id,
            SUM(p.price) AS sum_order
        FROM cte_orders_content oc
        CROSS JOIN UNNEST(product_ids) AS ps(product_id)
        INNER JOIN products AS p
            ON p.product_id = ps.product_id
        GROUP BY
            oc.order_id
    ),
    cte_order AS (
        SELECT
            ua.user_id,
            ua.order_id,
            oc.order_size,
            os.sum_order
        FROM cte_user_action AS ua
        INNER JOIN cte_orders_content AS oc
            ON oc.order_id = ua.order_id
        INNER JOIN cte_order_sum AS os
            ON os.order_id = ua.order_id
    )
SELECT
    user_id,
    COUNT(order_id) AS orders_count,
    ROUND(AVG(order_size), 2) AS avg_order_size,
    SUM(sum_order) AS sum_order_value,
    ROUND(AVG(sum_order), 2) AS avg_order_value,
    MIN(sum_order) AS min_order_value,
    MAX(sum_order) AS max_order_value
FROM cte_order
GROUP BY
    user_id
ORDER BY
    user_id
LIMIT 1000;