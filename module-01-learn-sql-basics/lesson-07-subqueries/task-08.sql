/*
Используя данные из таблицы user_actions, рассчитайте, сколько заказов сделал каждый пользователь и отразите это в столбце orders_count. В отдельном столбце orders_avg напротив каждого пользователя укажите среднее число заказов всех пользователей, округлив его до двух знаков после запятой. Также для каждого пользователя посчитайте отклонение числа заказов от среднего значения. Отклонение считайте так: число заказов «минус» округлённое среднее значение. Колонку с отклонением назовите orders_diff. Результат отсортируйте по возрастанию id пользователя. Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.

Поля в результирующей таблице: user_id, orders_count, orders_avg, orders_diff.
*/

WITH
    t1 AS (
        SELECT user_id, COUNT(order_id) AS orders_count FROM user_actions WHERE action = 'create_order' GROUP BY user_id
    ),
    t2 AS (
        SELECT ROUND(AVG(orders_count)::DECIMAL, 2) AS orders_avg
        FROM t1
    )
SELECT
    t1.user_id,
    t1.orders_count,
    t2.orders_avg,
    t1.orders_count - t2.orders_avg AS orders_diff
FROM t1
CROSS JOIN t2
ORDER BY
    t1.user_id
LIMIT 1000;