/*
Используя данные из таблицы user_actions, рассчитайте среднее число заказов всех пользователей нашего сервиса. Для этого сначала в подзапросе посчитайте, сколько заказов сделал каждый пользователь, а затем обратитесь к результату подзапроса в блоке FROM и уже в основном запросе усредните количество заказов по всем пользователям. Полученное среднее число заказов всех пользователей округлите до двух знаков после запятой. Колонку с этим значением назовите orders_avg.

Поле в результирующей таблице: orders_avg.
*/

SELECT
    ROUND(AVG(order_count)::DECIMAL, 2) AS orders_avg
FROM (
    SELECT user_id, COUNT(DISTINCT order_id) AS order_count FROM user_actions GROUP BY user_id
) AS t;