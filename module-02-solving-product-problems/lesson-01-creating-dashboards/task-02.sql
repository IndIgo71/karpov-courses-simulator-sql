/*
Для каждого дня, представленного в таблицах user_actions и courier_actions, дополнительно рассчитайте следующие показатели:

Прирост числа новых пользователей.
Прирост числа новых курьеров.
Прирост общего числа пользователей.
Прирост общего числа курьеров.
Показатели, рассчитанные на предыдущем шаге, также включите в результирующую таблицу.

Колонки с новыми показателями назовите соответственно new_users_change, new_couriers_change, total_users_growth, total_couriers_growth. 
Колонку с датами назовите date.
Все показатели прироста считайте в процентах относительно значений в предыдущий день. 
При расчёте показателей округляйте значения до двух знаков после запятой.
Результирующая таблица должна быть отсортирована по возрастанию даты.

Поля в результирующей таблице: date, new_users, new_couriers, total_users, total_couriers, 
new_users_change, new_couriers_change, total_users_growth, total_couriers_growth
*/

SELECT
    date,
    new_users,
    new_couriers,
    total_users,
    total_couriers,
    ROUND(new_users::DECIMAL * 100 / lu - 100, 2) AS new_users_change,
    ROUND(new_couriers::DECIMAL * 100 / lc - 100, 2) AS new_couriers_change,
    ROUND(total_users::DECIMAL * 100 / luu - 100, 2) AS total_users_growth,
    ROUND(total_couriers::DECIMAL * 100 / lcc - 100, 2) AS total_couriers_growth
FROM (
    WITH
        a AS (
            SELECT
                start_date AS date,
                new_users,
                new_couriers,
                SUM(new_users) OVER (ORDER BY start_date)::INT AS total_users,
                SUM(new_couriers) OVER (ORDER BY start_date)::INT AS total_couriers,
                LAG(new_users, 1) OVER () AS lu,
                LAG(new_couriers, 1) OVER () AS lc
            FROM (
                SELECT
                    start_date,
                    COUNT(courier_id) AS new_couriers
                FROM (
                    SELECT courier_id, MIN(time::date) AS start_date FROM courier_actions GROUP BY courier_id
                ) t1
                GROUP BY
                    start_date
            ) t2
            LEFT JOIN (
                SELECT
                    start_date,
                    COUNT(user_id) AS new_users
                FROM (
                    SELECT user_id, MIN(time::date) AS start_date FROM user_actions GROUP BY user_id
                ) t3
                GROUP BY
                    start_date
            ) t4
                USING (start_date)
        )
    SELECT
        date,
        new_users,
        new_couriers,
        total_users,
        total_couriers,
        lu,
        lc,
        LAG(total_users, 1) OVER () AS luu,
        LAG(total_couriers, 1) OVER () AS lcc
    FROM a
) AS b;