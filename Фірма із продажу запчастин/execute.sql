use spares

/*завдання 2: Також створити 1 запит з командою Update та 1 запит з командою Delete*/
delete from Manufacturer 
where Id>=5

update Detail set Note = 'Немає опису деталі'
where Note = '-'

/*завдання 3: Створити запити на вибірку даних*/

/*простий запит*/
select *
from Detail

/*з обчисленням */
select dd.IdDel, Sum(dd.CurrentDetailPrice*dd.Number) as 'Sum by order'
from DetailInDelivery as dd
group by dd.IdDel

/*з умовою*/
select d.Name, dd.CurrentDetailPrice
from DetailInDelivery as dd
inner join Detail as d on dd.IdDet = d.Id
where dd.CurrentDetailPrice>200

/*Like*/
select d.Name, d.Note 
from Detail as d
where d.Name LIKE '%System%'

/*робота з датами*/
select Day(d.DateDel) as 'Day by Day()', Month(d.DateDel) as 'Month by Month()', Year(d.DateDel) as 'Year by Year()'
from Delivery as d

/*запит на вибірку з двох таблиць (INNER JOIN)*/
select d.DateDel, dd.CurrentDetailPrice
from Delivery as d 
inner join DetailInDelivery as dd on d.Id = dd.IdDel

/*запит на вибірку з двох таблиць (LEFT JOIN  або RIGHT JOIN)*/
select m.Name, d.DateDel
from Manufacturer as m
right join Delivery as d on m.Id = d.IdMan

/*групувальний запит*/
select max(p.Val) as 'Максимальна ціна', d.Name
from Price as p
inner join PriceChange as pc on pc.PriceId = p.Id
inner join Detail as d on d.Id = pc.IdDet
group by d.Name

select dd.IdDel, count(d.Id) as 'Кількість деталей'
from Detail d 
inner join DetailInDelivery dd on dd.IdDet = d.Id
group by dd.IdDel

/*виконання трігеру*/
select *
from Manufacturer
select *
from PriceChange

/*виконання трігеру*/
insert into Manufacturer(Name, Adress, Phone)
values('Мій виробник', 'Адресааа', '+380505078049')

/*виконання процедури*/
exec InsertDetailInDelivery 1, 1, 5
exec InsertDetailInDelivery 2, 2, 7
exec InsertDetailInDelivery 2, 3, 10

select *
from DetailInDelivery

/*виконання функції*/
select * 
from Define_Delivery('2021-12-20')