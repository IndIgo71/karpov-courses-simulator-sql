/*
Из таблицы couriers выведите всю информацию о курьерах, которые в сентябре 2022 года доставили 30 и более заказов. Результат отсортируйте по возрастанию id курьера.

Поля в результирующей таблице: courier_id, birth_date, sex.
*/

SELECT
    courier_id,
    birth_date,
    sex
FROM couriers
WHERE
    courier_id IN (
        SELECT
            courier_id
        FROM courier_actions
        WHERE
            action = 'deliver_order'
            AND DATE_TRUNC('month', time) = '2022-09-01'
        GROUP BY
            courier_id
        HAVING
            COUNT(order_id) >= 30
    )
ORDER BY
    courier_id;