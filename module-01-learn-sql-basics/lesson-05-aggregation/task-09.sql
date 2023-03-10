/*
Снова воспользуйтесь функцией AGE() и рассчитайте разницу в возрасте между самым старым и самым молодым пользователями мужского пола в таблице users. Изменять тип данных колонки с результатом не нужно. Колонку с посчитанным значением назовите age_diff.

Полученная разница должна выглядеть следующим образом:
8350 days, 0:00:00


Поле в результирующей таблице: age_diff.
*/

SELECT MAX(AGE(birth_date)) - MIN(AGE(birth_date)) AS age_diff FROM users WHERE sex = 'male';