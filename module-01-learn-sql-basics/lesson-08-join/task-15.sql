/*
По таблицам courier_actions , orders и products определите 10 самых популярных товаров, доставленных в сентябре 2022 года. Самыми популярными товарами будем считать те, которые встречались в заказах чаще всего. Если товар встречается в одном заказе несколько раз (было куплено несколько единиц товара), то при подсчёте учитываем только одну единицу товара. Выведите наименования товаров и сколько раз они встречались в заказах. Новую колонку с количеством покупок товара назовите times_purchased. 

Поля в результирующей таблице: name, times_purchased.
*/

SELECT
    p.name,
    COUNT(DISTINCT o.order_id) AS times_purchased
FROM courier_actions ca
INNER JOIN orders o
    ON o.order_id = ca.order_id
CROSS JOIN UNNEST(o.product_ids) AS pl(product_id)
INNER JOIN products p
    ON p.product_id = pl.product_id
WHERE
    ca.action = 'deliver_order'
    AND DATE_TRUNC('month', ca.time) = '2022-09-01'
GROUP BY
    p.name
ORDER BY
    times_purchased DESC
LIMIT 10;