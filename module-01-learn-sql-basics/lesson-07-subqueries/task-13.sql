/*
Используя функцию unnest, определите 10 самых популярных товаров в таблице orders. Самыми популярными будем считать те, которые встречались в заказах чаще всего. Если товар встречается в одном заказе несколько раз (т.е. было куплено несколько единиц товара), то это тоже учитывается при подсчёте. 

Выведите id товаров и сколько раз они встречались в заказах. Новую колонку с количеством покупок товара назовите times_purchased.

Поля в результирующей таблице: product_id, times_purchased.
*/

SELECT
    UNNEST(product_ids) AS product_id,
    COUNT(*) AS times_purchased
FROM orders
GROUP BY
    product_id
ORDER BY
    times_purchased DESC
LIMIT 10;