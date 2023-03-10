/*
На основе информации в таблицах orders и products рассчитайте ежедневную выручку сервиса и отразите её в колонке daily_revenue.
Затем с помощью оконных функций и функций смещения посчитайте ежедневный прирост выручки. Прирост выручки отразите как в абсолютных значениях, так и в % относительно предыдущего дня.
Колонку с абсолютным приростом назовите revenue_growth_abs, а колонку с относительным — revenue_growth_percentage.

Для самого первого дня укажите прирост равным 0 в обеих колонках. При проведении расчётов отменённые заказы не учитывайте. Результат отсортируйте по колонке с датами по возрастанию.

Метрики daily_revenue, revenue_growth_abs, revenue_growth_percentage округлите до одного знака при помощи ROUND().

Поля в результирующей таблице: date, daily_revenue, revenue_growth_abs, revenue_growth_percentage.
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
    cte_order_date_price AS (
        SELECT
            date(creation_time) AS date,
            ROUND(SUM(p.price), 1) AS daily_revenue
        FROM cte_order_content oc
        INNER JOIN products p
            ON oc.product_id = p.product_id
        GROUP BY
            date(creation_time)
    ),
    cte_revenue_growth AS (
        SELECT
            date,
            daily_revenue,
            ROUND(COALESCE(daily_revenue - LAG(daily_revenue) OVER (), 0), 1) AS revenue_growth_abs
        FROM cte_order_date_price
    )
SELECT
    date,
    daily_revenue,
    revenue_growth_abs,
    ROUND(COALESCE(revenue_growth_abs / LAG(daily_revenue, 1) OVER () * 100, 0), 1) AS revenue_growth_percentage
FROM cte_revenue_growth
ORDER BY
    date;