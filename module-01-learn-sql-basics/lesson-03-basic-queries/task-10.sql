/*
Давайте представим, что по какой-то необъяснимой причине мы вдруг решили в одночасье повысить цену всех товаров в таблице products на 5%. Выведите наименования всех товаров, их старую и новую цену. Колонку с новой ценой назовите new_price. Результат отсортируйте по убыванию значений в новой колонке.

Поля в результирующей таблице: name, price, new_price.   
*/

SELECT
    name,
    price,
    price * 1.05 AS new_price
FROM products
ORDER BY
    new_price DESC;