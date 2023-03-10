/*
Из таблицы courier_actions отберите топ 10% курьеров по количеству доставленных за всё время заказов. Выведите id курьеров, количество доставленных заказов и порядковый номер курьера в соответствии с числом доставленных заказов.

У курьера, доставившего наибольшее число заказов, порядковый номер должен быть равен 1, а у курьера с наименьшим числом заказов —  числу, равному десяти процентам от общего количества курьеров в таблице courier_actions.

При расчёте номера последнего курьера округляйте значение до целого числа.

Колонки с количеством доставленных заказов и порядковым номером назовите соответственно orders_count и courier_rank. Результат отсортируйте по возрастанию порядкового номера курьера.

Поля в результирующей таблице: courier_id, orders_count, courier_rank.
*/

WITH
    t AS (
        SELECT
            courier_id,
            COUNT(DISTINCT order_id) AS orders_count
        FROM courier_actions
        WHERE
            action = 'deliver_order'
        GROUP BY
            courier_id
    ),
    t2 AS (
        SELECT
            courier_id,
            orders_count,
            COUNT(courier_id) OVER () AS total_cnt,
            ROW_NUMBER() OVER (ORDER BY orders_count DESC, courier_id) AS courier_rank
        FROM t
    )
SELECT
    courier_id,
    orders_count,
    courier_rank
FROM t2
WHERE
    CEIL(total_cnt * 0.1) >= courier_rank
ORDER BY
    courier_rank;