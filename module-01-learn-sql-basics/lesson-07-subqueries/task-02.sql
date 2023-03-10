/*
Повторите запрос из предыдущего задания, но теперь вместо подзапроса используйте оператор WITH и табличное выражение. Условия задачи те же.

Поле в результирующей таблице: orders_avg.
*/

WITH
    cte_order_cnt_by_user AS (
        SELECT user_id, COUNT(DISTINCT order_id) AS order_count FROM user_actions GROUP BY user_id
    )
SELECT
    ROUND(AVG(order_count) :: DECIMAL, 2) AS orders_avg
FROM cte_order_cnt_by_user;