/*
для каждого дня рассчитайте, за сколько минут в среднем курьеры доставляли свои заказы.

Колонку с показателем назовите minutes_to_deliver. Колонку с датами назовите date. 
При расчёте среднего времени доставки округляйте количество минут до целых значений. 
Учитывайте только доставленные заказы, отменённые заказы не учитывайте.

Результирующая таблица должна быть отсортирована по возрастанию даты.

Поля в результирующей таблице: date, minutes_to_deliver
*/

with t1 as (select time, order_id, time::date as date
            from courier_actions
            where action = 'accept_order' and order_id not in 
                                              (select order_id 
                                               from user_actions 
                                               where action = 'cancel_order')),
t2 as (select time, order_id, time::date as date
       from courier_actions
       where action = 'deliver_order' and order_id not in 
                                          (select order_id 
                                           from user_actions 
                                           where action = 'cancel_order'))
select t1.date, round(extract (epoch from avg(t2.time-t1.time)/60))::int as minutes_to_deliver
from t1
left join t2
on t1.order_id = t2.order_id
group by t1.date
order by t1.date
