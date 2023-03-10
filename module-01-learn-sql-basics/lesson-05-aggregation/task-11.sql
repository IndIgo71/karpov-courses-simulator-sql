/*
Посчитайте стоимость заказа, в котором будут три пачки сухариков, две пачки чипсов и один энергетический напиток. Колонку с рассчитанной стоимостью заказа назовите order_price.

Поле в результирующей таблице: order_price.
*/

SELECT
    SUM(CASE
            WHEN name = 'сухарики'
                THEN 3 * price
            WHEN name = 'чипсы'
                THEN 2 * price
            ELSE price
        END) AS order_price
FROM products
WHERE
    name IN ('сухарики', 'чипсы', 'энергетический напиток');