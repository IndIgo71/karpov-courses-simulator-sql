/*
Из таблицы users отберите id первых 100 пользователей (просто выберите первые 100 записей, используя простой LIMIT) и с помощью CROSS JOIN объедините их со всеми наименованиями товаров из таблицы products. Выведите две колонки — id пользователя и наименование товара. Результат отсортируйте сначала по возрастанию id пользователя, затем по имени товара — тоже по возрастанию.

Поля в результирующей таблице: user_id, name.
*/

WITH
    cte_first_100_user AS (
        SELECT user_id
        FROM users
        LIMIT 100
    )
SELECT
    u.user_id,
    p.name
FROM cte_first_100_user u
CROSS JOIN products p
ORDER BY
    u.user_id,
    p.name;