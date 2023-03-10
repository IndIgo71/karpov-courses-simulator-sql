/*
Посчитайте количество курьеров женского пола в таблице couriers. Полученный столбец назовите couriers_count.

Поле в результирующей таблице: couriers_count.
*/

SELECT COUNT(*) AS couriers_count FROM couriers WHERE sex = 'female';