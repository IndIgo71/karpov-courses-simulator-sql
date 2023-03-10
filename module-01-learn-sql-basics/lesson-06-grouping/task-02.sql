/*
Посчитайте максимальный возраст пользователей мужского и женского пола в таблице users. Возраст измерьте количеством полных лет. Новую колонку с возрастом назовите max_age. Результат отсортируйте по новой колонке по возрастанию возраста.

Поля в результирующей таблице: sex, max_age.
*/

SELECT sex, DATE_PART('year', AGE(MIN(birth_date))) AS max_age FROM users GROUP BY sex ORDER BY max_age;