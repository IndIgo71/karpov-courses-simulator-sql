/*
В прошлом уроке мы решили задачу для одного из менеджеров и посчитали НДС каждого товара. Вы долго смотрели на получившиеся расчёты и вас всё-таки замучила совесть: вы точно помните, что на отдельные группы товаров НДС составляет 10%, а не 20%.
Поскольку менеджер перестал отвечать на ваши сообщения, вы решили написать напрямую бухгалтеру компании и запросили список товаров, на которые распространяется НДС 10%.

Вот какой список вы получили:

'сахар', 'сухарики', 'сушки', 'семечки', 
'масло льняное', 'виноград', 'масло оливковое', 
'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 
'овсянка', 'макароны', 'баранина', 'апельсины', 
'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 
'мука', 'шпроты', 'сосиски', 'свинина', 'рис', 
'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 
'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки', 
'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины'

Как и в прошлый раз, вычислите НДС каждого товара в таблице products и рассчитайте цену без учёта НДС. Однако теперь примите во внимание, что для товаров из списка НДС составляет 10%. Для остальных товаров НДС тот же — 20%. Выведите всю информацию о товарах, включая сумму налога и цену без его учёта. Колонки с суммой налога и ценой без НДС назовите соответственно tax и price_before_tax. Округлите значения в этих колонках до двух знаков после запятой. Результат отсортируйте сначала по убыванию цены товара без учёта НДС, затем по возрастанию id товара.
Порядок расчёта налога тот же, что и в задании из прошлого урока.

Поля в результирующей таблице: product_id, name, price, tax, price_before_tax.
*/

WITH
    products_nds AS (
        SELECT
            product_id,
            name,
            price,
            CASE
                WHEN name IN ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград',
                              'масло оливковое', 'арбуз', 'батон', 'йогурт', 'сливки',
                              'гречка', 'овсянка', 'макароны', 'баранина', 'апельсины',
                              'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука',
                              'шпроты', 'сосиски', 'свинина', 'рис', 'масло кунжутное',
                              'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая',
                              'масло подсолнечное', 'яблоки', 'груши', 'лепешка', 'молоко',
                              'курица', 'лаваш', 'вафли', 'мандарины')
                    THEN 0.1
                ELSE 0.2
            END AS proc
        FROM products
    )
SELECT
    product_id,
    name,
    price,
    ROUND(price / (1 + proc) * proc, 2) AS tax,
    ROUND(price / (1 + proc), 2) AS price_before_tax
FROM products_nds
ORDER BY
    price_before_tax DESC,
    product_id;