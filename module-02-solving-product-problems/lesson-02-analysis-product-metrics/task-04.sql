/*
Для каждого дня недели рассчитайте следующие показатели:

Выручку на пользователя (ARPU).
Выручку на платящего пользователя (ARPPU).
Выручку на заказ (AOV).
При расчётах учитывайте данные только за период с 26 августа 2022 года по 8 сентября 2022 года включительно.

В результирующую таблицу включите как наименования дней недели (например, Monday), 
так и порядковый номер дня недели (от 1 до 7, где 1 — это Monday, 7 — это Sunday).

Колонки с показателями назовите соответственно arpu, arppu, aov. 
Колонку с наименованием дня недели назовите weekday, а колонку с порядковым номером дня недели weekday_number.
При расчёте всех показателей округляйте значения до двух знаков после запятой.
Результат должен быть отсортирован по возрастанию порядкового номера дня недели.

Поля в результирующей таблице: weekday, weekday_number, arpu, arppu, aov
*/

WITH
    cte_canceled_orders AS (
        SELECT order_id
        FROM user_actions
        WHERE action = 'cancel_order'
    ),
    cte_revenue_by_date AS (
        SELECT DISTINCT
            TO_CHAR(creation_time, 'Day') AS weekday,
            DATE_PART('isodow', creation_time) AS weekday_number,
            COUNT(DISTINCT order_id) AS orders,
            SUM(p.price) AS revenue
        FROM orders o
        CROSS JOIN UNNEST(product_ids) ps(product_id)
        INNER JOIN products p
            ON p.product_id = ps.product_id
        WHERE
            o.order_id NOT IN (
                SELECT order_id
                FROM cte_canceled_orders
            )
            AND creation_time BETWEEN '2022-08-26' AND '2022-09-09'
        GROUP BY
            weekday,
            weekday_number
    ),
    cte_users_and_orders AS (
        SELECT
            TO_CHAR(time, 'Day') AS weekday,
            DATE_PART('isodow', time) AS weekday_number,
            COUNT(DISTINCT user_id) AS users,
            COUNT(DISTINCT user_id) FILTER (
                WHERE order_id NOT IN (SELECT order_id FROM cte_canceled_orders)
            ) AS paying_users
        FROM user_actions
        WHERE
            time BETWEEN '2022-08-26' AND '2022-09-09'
        GROUP BY
            weekday,
            weekday_number
    )
SELECT
    r.weekday,
    r.weekday_number,
    ROUND(r.revenue::DECIMAL / uo.users, 2) AS arpu,
    ROUND(r.revenue::DECIMAL / uo.paying_users, 2) AS arppu,
    ROUND(r.revenue::DECIMAL / r.orders, 2) AS aov
FROM cte_revenue_by_date r
LEFT JOIN cte_users_and_orders uo
    ON r.weekday_number = uo.weekday_number
ORDER BY
    r.weekday_number;