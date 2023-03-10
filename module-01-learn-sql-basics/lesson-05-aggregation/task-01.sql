/*
Для начала решим простую задачу: выведите id всех уникальных пользователей из таблицы user_actions. Результат отсортируйте по возрастанию id.

Поле в результирующей таблице: user_i.
*/

SELECT DISTINCT user_id FROM user_actions ORDER BY user_id;