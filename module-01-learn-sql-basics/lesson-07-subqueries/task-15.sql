/*
Посчитайте возраст каждого пользователя в таблице users. Возраст измерьте числом полных лет, как мы делали в прошлых уроках. Возраст считайте относительно последней даты в таблице user_actions. В результат включите колонки с id пользователя и возрастом. Для тех пользователей, у которых в таблице users не указана дата рождения, укажите среднее значение возраста всех остальных пользователей, округлённое до целого числа. Колонку с возрастом назовите age. Результат отсортируйте по возрастанию id пользователя.

Поля в результирующей таблице: user_id, age.
*/

WITH
    cte_ua AS (
        SELECT MAX(time) AS max_time
        FROM user_actions
    ),
    cte_users AS (
        SELECT
            user_id,
            birth_date,
            DATE_PART('year', AGE((
                                      SELECT max_time
                                      FROM cte_ua
                                  ), birth_date)) AS age
        FROM users
    )
SELECT
    user_id,
    CASE
        WHEN birth_date IS NOT NULL
            THEN age
        ELSE ROUND((
            SELECT AVG(age) FILTER (WHERE birth_date IS NOT NULL)
            FROM cte_users
        ))
    END AS age
FROM cte_users
ORDER BY
    user_id;