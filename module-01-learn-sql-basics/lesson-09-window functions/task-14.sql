/*
На основе информации в таблицах orders и products рассчитайте стоимость каждого заказа, ежедневную выручку сервиса и долю стоимости каждого заказа в ежедневной выручке, выраженную в процентах.
В результат включите следующие колонки: id заказа, время создания заказа, стоимость заказа, выручку за день, в который был совершён заказ, а также долю стоимости заказа в выручке за день, выраженную в процентах.

При расчёте долей округляйте их до трёх знаков после запятой.

Результат отсортируйте сначала по убыванию даты совершения заказа (именно даты, а не времени), потом по убыванию доли заказа в выручке за день, затем по возрастанию id заказа.
При проведении расчётов отменённые заказы не учитывайте.

Поля в результирующей таблице:
order_id, creation_time, order_price, daily_revenue, percentage_of_daily_revenue.
*/

WITH
    cte_order_content AS (
        SELECT
            order_id,
            creation_time,
            product_ids,
            UNNEST(product_ids) AS product_id
        FROM orders
        WHERE
            order_id NOT IN (
                SELECT order_id
                FROM user_actions
                WHERE action = 'cancel_order'
            )
    ),
    cte_order_prices AS (
        SELECT
            oc.order_id,
            oc.creation_time,
            date(creation_time) AS creation_date,
            SUM(p.price) AS order_price
        FROM cte_order_content oc
        INNER JOIN products p
            ON oc.product_id = p.product_id
        GROUP BY
            oc.order_id,
            oc.creation_time,
            date(creation_time)
    ),
    cte_revenue AS (
        SELECT
            order_id,
            creation_time,
            creation_date,
            order_price,
            SUM(order_price) OVER (PARTITION BY creation_date) AS daily_revenue
        FROM cte_order_prices

    )
SELECT
    order_id,
    creation_time,
    order_price,
    daily_revenue,
    ROUND(order_price / daily_revenue * 100, 3) AS percentage_of_daily_revenue
FROM cte_revenue
ORDER BY
    creation_date DESC,
    percentage_of_daily_revenue DESC,
    order_id