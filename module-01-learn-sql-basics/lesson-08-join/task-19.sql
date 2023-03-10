/*
Выясните, кто заказывал и доставлял самые большие заказы. Самыми большими считайте заказы с наибольшим числом товаров.

Выведите id заказа, id пользователя и id курьера. Также в отдельных колонках укажите возраст пользователя и возраст курьера. Возраст измерьте числом полных лет, как мы делали в прошлых уроках. Считайте его относительно последней даты в таблице user_actions — как для пользователей, так и для курьеров. Колонки с возрастом назовите user_age и courier_age. Результат отсортируйте по возрастанию id заказа.

Поля в результирующей таблице: order_id, user_id, user_age, courier_id, courier_age.
*/

SELECT
    o.order_id,
    ua.user_id,
    ROUND(DATE_PART('year', AGE((
                                    SELECT MAX(time)
                                    FROM user_actions
                                ), u.birth_date))::INTEGER, 1) AS user_age,
    ca.courier_id,
    ROUND(DATE_PART('year', AGE((
                                    SELECT MAX(time)
                                    FROM courier_actions
                                ), c.birth_date))::INTEGER, 1) AS courier_age
FROM user_actions ua
INNER JOIN courier_actions ca
    ON ua.order_id = ca.order_id
INNER JOIN orders o
    ON o.order_id = ua.order_id
INNER JOIN users u
    ON u.user_id = ua.user_id
INNER JOIN couriers c
    ON c.courier_id = ca.courier_id
WHERE
    ca.action = 'deliver_order'
ORDER BY
    ARRAY_LENGTH(o.product_ids, 1) DESC,
    o.order_id
LIMIT 5;