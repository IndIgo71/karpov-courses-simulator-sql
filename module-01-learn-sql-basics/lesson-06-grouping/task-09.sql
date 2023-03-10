/*
А теперь отберите id только тех курьеров, которые в сентябре 2022 года успели доставить только по одному заказу. Таблица та же — courier_actions. Вновь выведите две колонки — id курьера и число доставленных заказов. Колонку с числом заказов назовите delivered_orders. Результат отсортируйте по возрастанию id курьера.

Поля в результирующей таблице: courier_id, delivered_orders.
*/

SELECT
    courier_id,
    COUNT(order_id) AS delivered_orders
FROM courier_actions
WHERE
    DATE_PART('year', time) = 2022
    AND DATE_PART('month', time) = 9
    AND action = 'deliver_order'
GROUP BY
    courier_id
HAVING
    COUNT(order_id) = 1
ORDER BY
    courier_id;