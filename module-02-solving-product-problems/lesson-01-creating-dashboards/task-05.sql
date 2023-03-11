/*
Для каждого дня рассчитайте следующие показатели:

Общее число заказов.
Число первых заказов (заказов, сделанных пользователями впервые).
Число заказов новых пользователей (заказов, сделанных пользователями в тот же день, когда они впервые воспользовались сервисом).
Долю первых заказов в общем числе заказов (долю п.2 в п.1).
Долю заказов новых пользователей в общем числе заказов (долю п.3 в п.1).
Колонки с показателями назовите соответственно orders, first_orders, new_users_orders, first_orders_share, new_users_orders_share. 
Колонку с датами назовите date. Проследите за тем, чтобы во всех случаях количество заказов было выражено целым числом. Все показатели с долями необходимо выразить в процентах. При расчёте долей округляйте значения до двух знаков после запятой.

Результат должен быть отсортирован по возрастанию даты.

Поля в результирующей таблице: date, orders, first_orders, new_users_orders, first_orders_share, new_users_orders_share
*/

SELECT
    date,
    orders,
    first_orders,
    new_users_orders::INT,
    ROUND(100 * first_orders::DECIMAL / orders, 2) AS first_orders_share,
    ROUND(100 * new_users_orders::DECIMAL / orders, 2) AS new_users_orders_share
FROM (
    SELECT
        creation_time::date AS date,
        COUNT(DISTINCT order_id) AS orders
    FROM orders
    WHERE
        order_id NOT IN (
            SELECT order_id
            FROM user_actions
            WHERE action = 'cancel_order'
        )
        AND order_id IN (
        SELECT order_id
        FROM courier_actions
        WHERE action = 'deliver_order'
    )
    GROUP BY
        date
) t5
LEFT JOIN (
    SELECT
        first_order_date AS date,
        COUNT(user_id) AS first_orders
    FROM (
        SELECT
            user_id,
            MIN(time::date) AS first_order_date
        FROM user_actions
        WHERE
            order_id NOT IN (
                SELECT order_id
                FROM user_actions
                WHERE action = 'cancel_order'
            )
        GROUP BY
            user_id
    ) t4
    GROUP BY
        first_order_date
) t7
    USING (date)
LEFT JOIN (
    SELECT
        start_date AS date,
        SUM(orders) AS new_users_orders
    FROM (
        SELECT
            t1.user_id,
            t1.start_date,
            COALESCE(t2.orders, 0) AS orders
        FROM (
            SELECT user_id, MIN(time::date) AS start_date FROM user_actions GROUP BY user_id
        ) t1
        LEFT JOIN (
            SELECT
                user_id,
                time::date AS date,
                COUNT(DISTINCT order_id) AS orders
            FROM user_actions
            WHERE
                order_id NOT IN (
                    SELECT order_id
                    FROM user_actions
                    WHERE action = 'cancel_order'
                )
            GROUP BY
                user_id,
                date
        ) t2
            ON t1.user_id = t2.user_id AND t1.start_date = t2.date
    ) t3
    GROUP BY
        start_date
) t6
    USING (date)
ORDER BY
    date;