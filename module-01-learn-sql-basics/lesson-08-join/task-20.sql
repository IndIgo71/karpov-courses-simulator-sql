/*
Выясните, какие пары товаров покупают вместе чаще всего.

Пары товаров сформируйте на основе таблицы с заказами. Отменённые заказы не учитывайте. В качестве результата выведите две колонки — колонку с парами наименований товаров и колонку со значениями, показывающими, сколько раз конкретная пара встретилась в заказах пользователей. Колонки назовите соответственно pair и count_pair.

Пары товаров должны быть представлены в виде списков из двух наименований. Пары товаров внутри списков должны быть отсортированы в порядке возрастания наименования. Результат отсортируйте сначала по убыванию частоты встречаемости пары товаров в заказах, затем по колонке pair — по возрастанию.

Поля в результирующей таблице: pair, count_pair.
*/

WITH
    main_table AS (
        SELECT DISTINCT
            order_id,
            product_id,
            name
        FROM (
            SELECT
                order_id,
                UNNEST(product_ids) AS product_id
            FROM orders
            WHERE
                order_id NOT IN (
                    SELECT order_id
                    FROM user_actions
                    WHERE action = 'cancel_order'
                )
                AND order_id IN (
                SELECT order_id
                FROM user_actions
                WHERE action = 'create_order'
            )
        ) t
        JOIN products
            USING (product_id)
        ORDER BY
            order_id,
            name
    )
SELECT
    pair,
    COUNT(order_id) AS count_pair
FROM (
    SELECT DISTINCT
        a.order_id,
        CASE
            WHEN a.name > b.name
                THEN STRING_TO_ARRAY(concat(b.name, '+', a.name), '+')
            ELSE STRING_TO_ARRAY(concat(a.name, '+', b.name), '+')
        END AS pair
    FROM main_table a
    JOIN main_table b
        ON a.order_id = b.order_id AND a.name != b.name
) t
GROUP BY
    pair
ORDER BY
    count_pair DESC,
    pair