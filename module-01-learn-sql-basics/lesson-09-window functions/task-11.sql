/*
Для каждой записи в таблице user_actions с помощью оконных функций и предложения FILTER посчитайте, сколько заказов сделал и сколько отменил каждый пользователь на момент совершения нового действия.
Иными словами, для каждого пользователя в каждый момент времени посчитайте две накопительные суммы — числа оформленных и числа отменённых заказов.
Если пользователь оформляет заказ, то число оформленных им заказов увеличивайте на 1, если отменяет — увеличивайте на 1 количество отмен.

Колонки с накопительными суммами числа оформленных и отменённых заказов назовите соответственно created_orders и canceled_orders.
На основе этих двух колонок для каждой записи пользователя посчитайте показатель cancel_rate, т.е. долю отменённых заказов в общем количестве оформленных заказов. Значения показателя округлите до двух знаков после запятой. Колонку с ним назовите cancel_rate.

В результате у вас должны получиться три новые колонки с динамическими показателями, которые изменяются во времени с каждым новым действием пользователя.

В результирующей таблице отразите все колонки из исходной таблицы вместе с новыми колонками.
Отсортируйте результат по колонкам user_id, order_id, time — по возрастанию значений в каждой.
Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.

Поля в результирующей таблице:
user_id, order_id, action, time, created_orders, canceled_orders, cancel_rate.  
*/

WITH
    t AS (
        SELECT
            user_id,
            order_id,
            action,
            time,
            COUNT(action)
                FILTER (WHERE action = 'create_order') OVER (PARTITION BY user_id ORDER BY time ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS created_orders,
            COUNT(action)
                FILTER (WHERE action = 'cancel_order') OVER (PARTITION BY user_id ORDER BY time ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS canceled_orders
        FROM user_actions
    )
SELECT
    user_id,
    order_id,
    action,
    time,
    created_orders,
    canceled_orders,
    ROUND(canceled_orders::DECIMAL / created_orders, 2) AS cancel_rate
FROM t
ORDER BY
    user_id,
    order_id,
    time
LIMIT 1000;
