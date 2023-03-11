/*
для каждого часа в сутках рассчитайте следующие показатели:

Число успешных (доставленных) заказов.
Число отменённых заказов.
Долю отменённых заказов в общем числе заказов (cancel rate).
Колонки с показателями назовите соответственно successful_orders, canceled_orders, cancel_rate. 
Колонку с часом оформления заказа назовите hour. П
ри расчёте доли отменённых заказов округляйте значения до трёх знаков после запятой.

Результирующая таблица должна быть отсортирована по возрастанию колонки с часом оформления заказа.

Поля в результирующей таблице: hour, successful_orders, canceled_orders, cancel_rate
*/

WITH
    t1 AS (
        SELECT
            EXTRACT(HOUR FROM creation_time) AS hour,
            COUNT(order_id) AS canceled_orders
        FROM orders
        WHERE
            order_id NOT IN (
                SELECT order_id
                FROM courier_actions
                WHERE action = 'deliver_order'
            )
        GROUP BY
            hour
        ORDER BY
            hour
    ),
    t2 AS (
        SELECT
            EXTRACT(HOUR FROM creation_time) AS hour,
            COUNT(order_id) AS successful_orders
        FROM orders
        WHERE
            order_id IN (
                SELECT order_id
                FROM courier_actions
                WHERE action = 'deliver_order'
            )
        GROUP BY
            hour
        ORDER BY
            hour
    )
SELECT
    t1.hour::INT,
    successful_orders,
    canceled_orders,
    ROUND(canceled_orders::DECIMAL / (successful_orders + canceled_orders), 3) AS cancel_rate
FROM t1
LEFT JOIN t2
    ON t1.hour = t2.hour;