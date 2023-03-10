/*
С помощью LEFT JOIN объедините таблицы user_actions и users по ключу user_id. Обратите внимание на порядок таблиц — слева users_actions, справа users. В результат включите две колонки с user_id из обеих таблиц. Эти две колонки назовите соответственно user_id_left и user_id_right. Также в результат включите колонки order_id, time, action, sex, birth_date. Отсортируйте получившуюся таблицу по возрастанию id пользователя (в колонке из левой таблицы).

Поля в результирующей таблице: user_id_left, user_id_right,  order_id, time, action, sex, birth_date
*/

SELECT
    user_actions.user_id AS user_id_left,
    users.user_id AS user_id_right,
    user_actions.order_id,
    user_actions.time,
    user_actions.action,
    users.sex,
    users.birth_date
FROM user_actions
LEFT JOIN users
    ON users.user_id = user_actions.user_id
ORDER BY
    user_actions.user_id;