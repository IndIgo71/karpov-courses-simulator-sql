/*
Теперь снова попробуйте немного переписать запрос из прошлого задания и посчитайте количество уникальных id в колонке user_id, пришедшей из левой таблицы user_actions. Выведите это количество в качестве результата. Колонку с посчитанным значением назовите users_count.

Поле в результирующей таблице: users_count
*/

SELECT
    COUNT(DISTINCT ua.user_id) AS users_count
FROM user_actions ua
LEFT JOIN users u
    ON u.user_id = ua.user_id;