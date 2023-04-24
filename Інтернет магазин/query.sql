/*1. Створити БД мовою SQL*/

create database [Internet-shop] /*база даних*/
use [Internet-shop]

create table Good( /*товар*/
Id int identity, /*код*/
[Name] varchar(30), /*назва*/
Price money, /*ціна*/
unit varchar(10), /*одиниці виміру*/
Primary key(Id) 
);

create table Discount(/*знижка*/
Id int identity(1,1), /*код*/
[Percentage] float, /*відсотки*/
primary key(Id)
);

create table Client(/*клієнт*/
Id int identity(1,1), /*код*/
Surname varchar(20), /*прізвище*/
[Name] varchar(20), /*ім'я*/
MiddleName varchar(20), /*по-батькові*/
Adress varchar(50), /*адреса*/
Phone varchar(13), /*телефон*/
[E-mail] varchar(30), /*пошта*/
IdDiscount int default 1, /*наявність знижки: 1 - немає знижки, 2 - є знижка*/
primary key(Id), 
foreign key(IdDiscount) references Discount(Id)
);

create table Sale(/*заказ*/
Id int identity(1,1), /*код*/
IdClient int, /*клієнт*/
DateSale date default getdate(), /*дата покупки*/
DateDelivery date default getdate() + 3, /*дата доставки*/
Amount money default 0, /*вартість заказу*/
primary key(Id), 
foreign key(IdClient) references Client(Id) 
);

create table GoodInSale(/*товари в заказі*/
Id int identity(1,1), /*код*/
IdGood int, /*товар*/
Number int, /*кількість*/
IdSale int, /*який заказ*/
primary key(Id), 
foreign key(IdGood) references Good(Id), 
foreign key(IdSale) references Sale(Id)
); 

create table Storage(/*склад*/
Id int identity(1,1), /*код*/
IdGood int, /*товар*/
Number int, /*кількість*/
primary key(Id), 
foreign key(IdGood) references Good(Id)
);



/*2.1. Внести дані в БД (Insert).*/
insert into Good([Name], Price, unit)
values('Ноутбук', 2000, 'шт'), 
('Мука', 10, 'кг'), 
('Вода', 11, 'л'), 
('Свічка', 20, 'шт'), 
('Картопля', 15, 'кг'), 
('Бензин', 30, 'л')

insert into Discount([Percentage])
values(0), 
(2)

insert into Client(Surname, [Name], MiddleName, Adress, Phone, [E-mail])
values('Іваненко', 'Іван', 'Іванович', 'Івановська, 6', '+380980975643', 'ivanenko@gmail.com'), 
('Петренко', 'Петро', 'Петрович', 'Петровська, 9', '+380506784635', 'petrenko@gmail.com'), 
('Василюк', 'Василь', 'Васильович', 'Васильківська, 11', '+380978675463', 'vasyluk@ukr.net')

insert into Storage(IdGood, Number)
values(1, 50), 
(2, 105), 
(3, 210), 
(4, 103), 
(5, 95), 
(6, 100)

insert into Sale(IdClient)
values(1),
(2), 
(3)


/*4.1. Для відслідковування кількості товару на складі напишемо трігер*/
go
create trigger Manipulate_storage on GoodInSale for insert
as
declare @bought int, @IdGood int
if @@ROWCOUNT = 1
begin
	if not exists(
					select * 
					from inserted i
					where -i.Number <= all(
										select s.Number 
										from Storage s, GoodInSale gis
										where s.IdGood = gis.IdGood))
	begin 
		rollback tran print 'Відміна замовлення: на складі недостатньо товарів'
	end;
	else
	begin
		select @bought = i.Number from inserted i 
		select @IdGood = i.IdGood from inserted i

		update Storage 
		set Number = Number - @bought
		where @IdGood = storage.Id
	end; 
end;

/*4.4. також напишемо для додавання в GoodInSale значень процедуру: */
go
create procedure insertInGIS(@IdSale int, @IdGood int, @Number int)
as
insert into GoodInSale(IdSale, IdGood, Number)
values(@IdSale, @IdGood, @Number)

/*виконання процедури - внесення даних в таблицю GoodInSale*/
exec insertInGIS 1, 2, 2 
exec insertInGIS 1, 1, 5
exec insertInGIS 2, 3, 7

/*перевірка*/
select *
from GoodInSale
select *
from Storage



/*Продовження завдання 2*/
/*2.2. Також створити 1 запит з командою Update та 1 запит з командою Delete */
/*встановлюємо значення кількості 0*/
update Storage 
set Number = 0
where IdGood = 6
/*видаляємо записи, де кількість 0*/
delete Storage 
where Number = 0
/*перевірка*/
select *
from Storage




/*3. Створити запити на вибірку даних*/
-- простий запит
select (c.[Name] + ' ' + c.MiddleName + ' ') as 'Client', c.Phone
from Client c

-- запит з обчисленням
select count(s.IdGood) as 'Кількість найменувань на складі'
from Storage s

-- запит з умовою
select count(s.IdGood) as 'Кількість наявного товару на складі'
from Storage s
where s.Number != 0 

-- запит з командою Like
select g.[Name]
from Good g
where g.unit like 'шт'

-- робота з датами 
select s.Id, Day(s.DateSale) as 'День', Month(s.DateSale) as 'Місяць', Year(s.DateSale) as 'Рік'
from Sale s
where s.Id = 3

-- запит на вибірку з двох таблиць (inner join)
select g.Name as 'Назва товару', s.Number 'Кількість на складі'
from Storage s
inner join Good g on g.Id=s.IdGood

-- запит на вибірку з двох таблиць (left або right)
select (c.[Name] + ' ' + c.MiddleName + ' ') as 'Client', s.Id as 'Номер заказа'
from Client c
left join Sale s on c.Id = s.IdClient 

-- групувальний запит 
select g.Name as 'Товар', s.Id as 'Заказ', Sum(gis.Number) as 'Кількість в заказі'
from GoodInSale as gis 
inner join Good as g on g.Id = gis.IdGood 
inner join Sale as s on s.Id = gis.IdSale
group by g.Name, s.Id

/*4. Створити*/
/*4.1. (трігер)*/
/* було створено вище */

/*4.2. представлення - які товари зі складу знаходяться в заказах*/
go
create view Goods_In_delivery 
as
select g.Id as IdGood, g.Name as 'Good', s.Id as 'Sale', gis.Number as 'Goods in sale', st.Number as 'Number in storage'
from Good g
inner join Storage st on st.IdGood = g.Id 
inner join GoodInSale gis on gis.IdGood = g.Id
inner join Sale s on s.Id = gis.IdSale

/*4.3. на основі представлення створити запит - дані з представлення в яких ціна більше 50*/
select *
from Goods_In_delivery gid 
inner join Good g on gid.IdGood = g.Id
where g.Price>50

/*4.4. процедура також була створена вище*/
/*процедура - підрахунок загального чека для клієнта + перевірка чи сума замовлення більше 5000 + додавання клієнту знижки*/
go
create procedure ToSaleDiscount(@IdSale int)
as
begin
	declare /*змінні*/
		@IdClient int, /*клінєт, якиий відповідає даному замовленню*/
		@Total money, /*попередня сума замовлення*/
		@Discount float /*знижка*/
	select @IdClient = c.Id /*клієнт, прив'язаний до заданого замовлення*/
					from Client as c
					inner join Sale as s on s.IdClient = c.Id /*вказане замовлення*/
					where s.Id = @IdSale
	select @Total = Sum(gis.Number*g.Price) /*обчислення суми заказа без знижки*/ 
						from Sale as s /*вказане замовлення*/
						inner join GoodInSale as gis on gis.IdSale = s.Id /*товари у замовленні, для кількості*/
						inner join Good as g on g.Id = gis.IdGood /*товар, для ціни*/
						where s.Id = @IdSale/*лише по заданому замовленню*/
						group by s.Id
	/*зміна відсотку в залежності від ціни та обрахування ціни*/
	if @Total>5000 
	begin
		update Client 
		set IdDiscount = 2
		where Id = @IdClient
	end;

	/*не дозволить скидувати знижку, якщо постійний клієнт купить менше ніж на 5000 грн*/
	update Client 
	set IdDiscount = case 
	when IdDiscount = 2 then 2 
	else 1 end

	/*відсоток знижки*/
	select @Discount = d.[Percentage]/cast(100 as float) /*визначення відсотку*/
						from Discount as d /*таблиця з відсотками*/
						inner join Client as c on c.IdDiscount = d.Id /*до клієнта прив'язка знижки йде*/
						where c.Id = @IdClient /*по вказаному клієнту*/
	set @Total = @Total * (1 - @Discount)
	
	/*додавання ціни до замовлення*/
	update Sale
	set Amount = @Total
	where Id = @IdSale
end; 

exec ToSaleDiscount 1
exec ToSaleDiscount 2
select *
from Sale
select *
from Client

/*Перевіримо стовпець вже із знижкою, сума заказу якого буде менше 5000*/
insert into Sale(IdClient)
values(1) /*він вже має статус постійного клієнта*/
select * from Sale
exec insertInGIS 4, 2, 2 
exec ToSaleDiscount 4

select *
from Sale
select *
from Client

/*функція - повертає кількість продаж за певну дату*/
go
create function CountSales(@YourData date)
returns int
as
begin
	declare @x int
	select @x = count(s.Id)
		from Sale s 
		where s.DateSale = @YourData 
	return @x
end; 

insert into Sale(IdClient, DateSale, DateDelivery)
values(3, '2021-12-20', '2021-12-23'), 
(2, '2021-12-24', '2021-12-25')
select *
from Sale
select dbo.CountSales('2021-12-20') as 'Number of sales'
select dbo.CountSales('2021-12-24') as 'Number of sales'