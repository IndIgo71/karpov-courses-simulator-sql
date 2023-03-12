/*
Для каждого дня рассчитайте следующие показатели:

Выручку, полученную в этот день.
Суммарную выручку на текущий день.
Прирост выручки, полученной в этот день, относительно значения выручки за предыдущий день.
Колонки с показателями назовите соответственно revenue, total_revenue, revenue_change. Колонку с датами назовите date.

Прирост выручки рассчитайте в процентах и округлите значения до двух знаков после запятой.

Результат должен быть отсортирован по возрастанию даты.

Поля в результирующей таблице: date, revenue, total_revenue, revenue_change
*/

WITH
    cte_revenue_by_date AS (
        SELECT DISTINCT
            o.creation_time::date AS date,
            SUM(p.price) AS revenue
        FROM orders o
        CROSS JOIN UNNEST(product_ids) ps(product_id)
        INNER JOIN products p
            ON p.product_id = ps.product_id
        WHERE
            o.order_id NOT IN (
                SELECT order_id
                FROM user_actions
                WHERE action = 'cancel_order'
            )
        GROUP BY
            date
    )
SELECT
    date,
    revenue,
    SUM(revenue) OVER (ORDER BY date) AS total_revenue,
    ROUND(100 * (revenue - LAG(revenue, 1) OVER (ORDER BY date))::DECIMAL / LAG(revenue, 1) OVER (ORDER BY date),
          2) AS revenue_change
FROM cte_revenue_by_date;