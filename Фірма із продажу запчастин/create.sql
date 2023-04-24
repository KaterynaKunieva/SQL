/*завдання 1:  Створити БД мовою SQL*/
create database spares 
use spares

go
create table Manufacturer(
Id int identity(1,1) not null, 
[Name] varchar(50) not null, 
Adress varchar(200) not null, 
Phone varchar(15) not null, 
primary key(Id) 
); /*постачальник*/

go
create table Detail(
Id int identity(1,1) not null,
[Name] varchar(50) not null, 
Article varchar(10) not null unique, 
Note varchar(500) not null, 
primary key (Id)
); /* деталь */

go
create table Price(
Id int identity(1,1) not null,
Val money not null, 
check(Val>0), 
primary key(Id)
); -- ціна

go
create table PriceChange(
Id int identity(1,1), 
PriceId int, 
DateChange date, 
ManId int,
IdDet int, 
primary key(Id), 
foreign key(ManId) references Manufacturer(Id), 
foreign key(PriceId) references Price(Id), 
foreign key(IdDet) references Detail(Id)
); -- зміна цін

go
create table Delivery(
Id int identity(1,1) not null, 
IdMan int, 
DateDel date not null, 
primary key (Id), 
foreign key(IdMan) references Manufacturer(Id)
); /*поставки*/

go
create table DetailInDelivery(
IdDel int,
IdDet int, 
Number int, 
CurrentDetailPrice money,
foreign key(IdDet) references Detail(Id), 
foreign key(IdDel) references Delivery(Id)
); /*таблиця для того, щоб в 1 заказі було декілька товарів*/


/*5. Створити*/
/*трігер - після insert в Manufacturer буде додаватися запис до PriceChange з поточною датою, першою ціною для всіх деталей*/
go
create trigger Manufacturer_insert on Manufacturer after insert 
as 
insert into PriceChange(PriceId, DateChange, ManId, IdDet)
SELECT 1, GETDATE(), (select Id from inserted), D.Id from Detail D;

/*представлення */
go 
create view my_view
as
WITH Total_Sum_Order (IdDel, SumByOrder)  
AS  
(  
    select dd.IdDel as IdDel, Sum(dd.CurrentDetailPrice*dd.Number) as SumByOrder
	from DetailInDelivery as dd
	group by dd.IdDel
)
select *, r.SumByDetail/r.SumByOrder as [Percentage]
from 
(select *, rez.Number*rez.CurrentDetailPrice as SumByDetail
from(
select dl.Id as 'Id Delivery', dl.DateDel as 'Date Delivery', dt.[Name] as 'Detail name', dt.Note as 'Detail Note', dd.Number as Number, 
  m.Name as 'Manufacturer name', m.Adress as 'Manufacturer adress', m.Phone as 'Manufacturer phone', dd.CurrentDetailPrice as CurrentDetailPrice, 
  pc.DateChange as 'Last Detail Price Date Change', tso.SumByOrder as SumByOrder
from Delivery as dl  
  inner join DetailInDelivery as dd on dd.IdDel = dl.Id
  inner join Detail as dt on dd.IdDet = dt.Id
  inner join PriceChange as pc on pc.Id = (select TOP 1 PC2.Id
											From PriceChange PC2 
											where PC2.IdDet = dt.Id and PC2.ManId = dl.IdMan and PC2.DateChange < dl.DateDel 
											ORDER BY PC2.DateChange DESC)
  inner join Manufacturer as m on pc.ManId = m.Id 
  inner join Price as p on pc.PriceId = p.Id
  inner join Total_Sum_Order as tso on tso.IdDel = dl.Id
group by dl.Id, dl.DateDel, dt.[Name], dt.Note, m.Name, m.Adress, m.Phone, dd.CurrentDetailPrice, pc.DateChange, tso.SumByOrder, Number) as rez) as r


/*на основі представлення створити запит */
select *
from my_view as mv
where mv.SumByOrder < 10000


/*процедуру - додає деталь у заказ із останньою доданою ціною*/
go
create procedure InsertDetailInDelivery
	@IdDel int, 
	@IdDet int, 
	@Number int
as
	declare @curr_price_detail int;
	set @curr_price_detail = (
							Select Top 1 Val from Price p 
							inner join PriceChange PC on PC.PriceId = p.Id
							inner join Manufacturer M on M.Id = PC.ManId
							inner join Delivery D on D.IdMan = M.Id
							where d.Id = @IdDel and PC.DateChange < d.DateDel and PC.IdDet = @IdDet
							order by PC.DateChange DESC)
	insert into DetailInDelivery(IdDel, IdDet, Number, CurrentDetailPrice)
	values(@IdDel, @IdDet, @Number, @curr_price_detail)


/*функцію - повертає таблицю із відправленнями у вказаний день*/
go
create function Define_Delivery(@Date date)
RETURNS TABLE
AS
RETURN
	select Id 
	from Delivery 
	where DateDel = @Date