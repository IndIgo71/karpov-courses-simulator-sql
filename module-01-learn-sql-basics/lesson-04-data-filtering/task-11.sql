/*
Из таблицы user_actions получите информацию о всех отменах заказов, которые пользователи совершали в течение августа 2022 года по средам с 12:00 до 15:59. Результат отсортируйте по времени отмены заказа — от самых последних отмен к самым первым.

Поля в результирующей таблице: user_id, order_id, action, time.
*/

SELECT
    user_id,
    order_id,
    action,
    time
FROM user_actions
WHERE
    action = 'cancel_order'
    AND DATE_PART('year', time) = 2022
    AND DATE_PART('month', time) = 8
    AND DATE_PART('dow', time) = 3
    AND DATE_PART('hour', time) BETWEEN 12 AND 15
ORDER BY
    time DESC;