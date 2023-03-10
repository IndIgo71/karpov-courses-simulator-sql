/*
На основе запроса из предыдущего задания для каждого пользователя рассчитайте, сколько в среднем времени проходит между его заказами. Не считайте этот показатель для тех пользователей, которые за всё время оформили лишь один заказ. Полученное среднее значение (интервал) переведите в часы, а затем округлите до целого числа. Колонку со средним значением часов назовите hours_between_orders. Результат отсортируйте по возрастанию id пользователя.
Добавьте LIMIT 1000.
Поля в результирующей таблице: user_id, hours_between_orders.  
*/

WITH
    t AS (
        SELECT
            user_id,
            EXTRACT(EPOCH FROM AGE(time, LAG(time) OVER (PARTITION BY user_id ORDER BY time))) AS hours_between_orders
        FROM user_actions
        WHERE
            order_id NOT IN (
                SELECT order_id
                FROM user_actions
                WHERE action = 'cancel_order'
            )
    )
SELECT
    user_id,
    ROUND(AVG(COALESCE(hours_between_orders, 0)) / 3600) AS hours_between_orders
FROM t
WHERE
    hours_between_orders IS NOT NULL
GROUP BY
    user_id
ORDER BY
    user_id
LIMIT 1000;