/*
Для каждого дня рассчитайте следующие показатели:

Выручку, полученную в этот день.
Затраты, образовавшиеся в этот день.
Сумму НДС с продажи товаров в этот день.
Валовую прибыль в этот день (выручка за вычетом затрат и НДС).
Суммарную выручку на текущий день.
Суммарные затраты на текущий день.
Суммарный НДС на текущий день.
Суммарную валовую прибыль на текущий день.
Долю валовой прибыли в выручке за этот день (долю п.4 в п.1).
Долю суммарной валовой прибыли в суммарной выручке на текущий день (долю п.8 в п.5).
Колонки с показателями назовите соответственно revenue, costs, tax, gross_profit, total_revenue, total_costs, total_tax, total_gross_profit, 
gross_profit_ratio, total_gross_profit_ratio
Колонку с датами назовите date.

Долю валовой прибыли в выручке необходимо выразить в процентах, округлив значения до двух знаков после запятой.
Результат должен быть отсортирован по возрастанию даты.

Поля в результирующей таблице: date, revenue, costs, tax, gross_profit, total_revenue, total_costs, total_tax, total_gross_profit, gross_profit_ratio,total_gross_profit_ratio
*/

WITH
    q1 AS (
        SELECT
            date,
            SUM(order_sb) AS order_sb_t,
            CASE WHEN DATE_PART('month', date) = 8 THEN 120000 ELSE 150000 END AS fixed
        FROM (
            SELECT
                creation_time::date AS date,
                order_id,
                CASE WHEN DATE_PART('month', creation_time) = 8 THEN 140 ELSE 115 END AS order_sb
            FROM orders
            WHERE
                order_id NOT IN (
                    SELECT order_id
                    FROM user_actions
                    WHERE action = 'cancel_order'
                )
        ) t
        GROUP BY
            date
        ORDER BY
            date
    ),
    q2 AS (
        WITH
            b AS (
                SELECT
                    date,
                    courier_id,
                    order_count,
                    del_pay,
                    CASE
                        WHEN DATE_PART('month', date) = 8 AND order_count >= 5
                            THEN 400
                        WHEN DATE_PART('month', date) = 9 AND order_count >= 5
                            THEN 500
                        ELSE 0
                    END AS bonus
                FROM (
                    SELECT
                        time::date AS date,
                        courier_id,
                        COUNT(order_id) order_count,
                        COUNT(order_id) * 150 AS del_pay
                    FROM courier_actions
                    WHERE
                        action = 'deliver_order'
                    GROUP BY
                        courier_id,
                        date
                ) a
            )
        SELECT
            date,
            SUM(del_pay) AS del_pay_t,
            SUM(bonus) AS bonus_t
        FROM b
        GROUP BY
            date
        ORDER BY
            date
    ),
    cost AS (
        SELECT
            date,
            (order_sb_t + fixed + del_pay_t + bonus_t)::INT AS costs
        FROM (
            SELECT
                q1.date,
                order_sb_t,
                fixed,
                del_pay_t,
                bonus_t
            FROM q1
            LEFT JOIN q2
                USING (date)
        ) c
    ),
    w AS (
        SELECT
            creation_time::date AS date,
            order_id,
            UNNEST(product_ids) AS product_id
        FROM orders
        WHERE
            order_id NOT IN (
                SELECT order_id
                FROM user_actions
                WHERE action = 'cancel_order'
            )
    ),
    e AS (
        SELECT
            product_id,
            name,
            price,
            CASE
                WHEN name IN ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград', 'масло оливковое',
                              'арбуз',
                              'батон', 'йогурт', 'сливки', 'гречка', 'овсянка', 'макароны', 'баранина', 'апельсины',
                              'бублики',
                              'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина',
                              'рис',
                              'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая',
                              'масло подсолнечное',
                              'яблоки', 'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины')
                    THEN ROUND(price / 110 * 10, 2)
                ELSE ROUND(price / 120 * 20, 2)
            END AS tax
        FROM products
    ),
    tax AS (
        SELECT
            date,
            SUM(tax) AS tax
        FROM w
        LEFT JOIN e
            USING (product_id)
        GROUP BY
            date
        ORDER BY
            date
    ),
    rev AS (
        SELECT
            date,
            SUM(order_sum) AS revenue
        FROM (
            SELECT DISTINCT
                date,
                order_id,
                SUM(price) AS order_sum
            FROM w
            LEFT JOIN e
                USING (product_id)
            GROUP BY
                order_id,
                date
        ) t3
        GROUP BY
            date
    )
SELECT
    date,
    revenue,
    costs,
    tax,
    gross_profit,
    total_revenue,
    total_costs::DECIMAL,
    total_tax,
    total_gross_profit,
    ROUND(gross_profit / revenue * 100, 2) AS gross_profit_ratio,
    ROUND(total_gross_profit / total_revenue * 100, 2) AS total_gross_profit_ratio
FROM (
    SELECT
        rev.date,
        revenue,
        costs,
        tax,
        (revenue - costs - tax) AS gross_profit,
        SUM(revenue) OVER (ORDER BY date) AS total_revenue,
        SUM(costs) OVER (ORDER BY date) AS total_costs,
        SUM(tax) OVER (ORDER BY date) AS total_tax,
        SUM(revenue - costs - tax) OVER (ORDER BY date) AS total_gross_profit
    FROM rev
    LEFT JOIN cost
        USING (date)
    LEFT JOIN tax
        USING (date)
) p;