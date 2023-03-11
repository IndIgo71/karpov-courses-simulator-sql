/*
для каждого дня рассчитайте следующие показатели:

Число платящих пользователей на одного активного курьера.
Число заказов на одного активного курьера.
Колонки с показателями назовите соответственно users_per_courier и orders_per_courier. 
Колонку с датами назовите date. При расчёте показателей округляйте значения до двух знаков после запятой.

В расчётах учитывайте только неотменённые заказы. 
При расчёте числа курьеров учитывайте только тех, которые в текущий день приняли хотя бы один заказ (который был в последствии доставлен) 
или доставили любой заказ. При расчёте числа пользователей также учитывайте только тех, кто сделал хотя бы один заказ.

Результирующая таблица должна быть отсортирована по возрастанию даты.

Поля в результирующей таблице: date, users_per_courier, orders_per_courier
*/

WITH
    cte_users_with_orders as (
        SELECT
            time::date as date,
            user_id,
            order_id
        from user_actions
        WHERE
            action = 'create_order'
            AND order_id NOT IN (
                SELECT order_id
                FROM user_actions
                WHERE action = 'cancel_order'
            )
    ),
    cte_paying_users AS (
        SELECT
            date,
            COUNT(DISTINCT user_id) AS paying_users
        FROM cte_users_with_orders
        GROUP BY
            date
        ORDER BY
            date
    ),
    cte_active_couriers AS (
        SELECT
            time::date AS date,
            COUNT(DISTINCT courier_id) AS active_couriers
        FROM courier_actions
        WHERE
            action != 'cancel_order'
            AND order_id NOT IN (
                SELECT order_id
                FROM user_actions
                WHERE action = 'cancel_order'
            )
        GROUP BY
            date
        ORDER BY
            date
    ),
    cte_orders AS (
        SELECT
            date,
            COUNT(order_id) AS orders
        FROM cte_users_with_orders
        GROUP BY
            date
        ORDER BY
            date
    )
SELECT
    cte_active_couriers.date,
    ROUND(paying_users::DECIMAL / active_couriers, 2) AS users_per_courier,
    ROUND(orders::DECIMAL / active_couriers, 2) AS orders_per_courier
FROM cte_paying_users
LEFT JOIN cte_active_couriers
    ON cte_paying_users.date = cte_active_couriers.date
LEFT JOIN cte_orders
    ON cte_paying_users.date = cte_orders.date;
