/*
Назначьте скидку 15% на товары, цена которых превышает среднюю цену на все товары на 50 и более рублей, а также скидку 10% на товары, цена которых ниже средней на 50 и более рублей. Цену остальных товаров внутри диапазона (среднее - 50; среднее + 50) оставьте без изменений. При расчёте средней цены, округлите её до двух знаков после запятой.

Выведите информацию о всех товарах с указанием старой и новой цены. Колонку с новой ценой назовите new_price. Результат отсортируйте сначала по убыванию прежней цены в колонке price, затем по возрастанию id товара.

Поля в результирующей таблице: product_id, name, price, new_price.
*/

WITH
    cte_avg_product_price AS (
        SELECT ROUND(AVG(price), 2) AS avg_price
        FROM products
    )
SELECT
    p.product_id,
    p.name,
    p.price,
    CASE
        WHEN p.price - ap.avg_price >= 50
            THEN p.price * 0.85
        WHEN ap.avg_price - p.price >= 50
            THEN p.price * 0.9
        ELSE p.price
    END AS new_price
FROM products p
CROSS JOIN cte_avg_product_price ap
ORDER BY
    p.price DESC,
    p.product_id;