/*
Из таблицы user_actions выведите всю информацию о действиях пользователей с id 170, 200 и 230 за период с 25 августа по 4 сентября 2022 года включительно. Результат отсортируйте по времени совершения действия — от самых поздних действий к самым первым.

Поля в результирующей таблице: user_id, order_id, action, time.
*/

SELECT
    user_id,
    order_id,
    action,
    time
FROM user_actions
WHERE
    user_id IN (170, 200, 230)
    AND date(time) BETWEEN TO_DATE('2022-08-25', 'yyyy-mm-dd') AND TO_DATE('2022-09-04', 'yyyy-mm-dd')
ORDER BY
    time DESC;