/*
В таблице products найдите все товары, содержащие в своём названии последовательность символов «чай» (без кавычек). Выведите две колонки: id продукта и его название.

Поля в результирующей таблице: product_id, name.
*/

SELECT product_id, name FROM products WHERE name LIKE '%чай%';