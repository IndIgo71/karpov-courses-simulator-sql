/*
Из таблицы orders выведите id и содержимое заказов, которые включают хотя бы один из пяти самых дорогих товаров, доступных в нашем сервисе. Результат отсортируйте по возрастанию id заказа.

Поля в результирующей таблице: order_id, product_ids.
*/

SELECT
    order_id,
    product_ids
FROM (
    SELECT order_id, product_ids, UNNEST(product_ids) AS product_id FROM orders
) AS t
WHERE
    product_id IN (
        SELECT product_id
        FROM products
        ORDER BY price DESC
        LIMIT 5
    )
GROUP BY
    order_id,
    product_ids
ORDER BY
    order_id;