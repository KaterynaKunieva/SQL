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
);

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
);

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


/*завдання 2: Внести дані в БД (Insert).*/

insert into Manufacturer([Name], Adress, Phone)
values('BestFind', 'Mashynobudivna St, 50', '+380632338185'),
('72.ua', 'Korabelna St, 8', '+380664327272'), 
('FD crankshaft', 'Elektrotekhnichna St, 47b', '+380685255775'), 
('Tov Omeha', 'Valentyny Chaiky St, 4', '+380577136900'), 
('AMS', 'Bohatyrska St, 12', '+380976024245'), 
('VAG UA', 'Vulytsya Pivnichno-Syrets`ka, 49В', '+380689668082'), 
('Kiev Autopromzapchst', 'Yuriya Shums`koho St, 5', '-'), 
('Avtomahazyn Ooo Avtokompanyya Khors', 'Shakhtarska St, 8', '+380444514199'), 
('Sto Avtolot', 'Saperno-Slobidska St, 25', '+380971709016'), 
('Avtonova-D', 'Baltiis`kyi Ln, 20', '+380444909190')

insert into Delivery(DateDel, IdMan)
values('2021-12-20', 3), 
('2021-12-21', 2), 
('2021-12-22', 1),
('2021-12-23', 4)

insert into Price(Val)
values(1000), 
(2000), 
(900), 
(2), 
(60000)

insert into Detail([Name], Article, Note)
values('Brake pads', 'a', 'Гальмова колодка — частина гальмівної системи і її основний робочий компонент.'), 
('Disks', 'b', 'Частина колеса, обідок.'),
('Clutch', 'c', 'Зчеплення (муфта зчеплення) — механізм, що з*єднує двигун із трансмісією та дає змогу тимчасово роз*єднувати їх під час перемикання передач, гальмування і зупинки'), 
('Battery', 'd', 'Акумулятор (енергії) (лат. — збирач) — пристрій, в якому нагромаджується (акумулюється) енергія.'), 
('Headlights', 'e', 'Фара (від грецького «Фарос») — джерело спрямованого світла, встановлений на транспортному засобі, призначений для освітлення навколишньої місцевості, дороги.'), 
('Radiator', 'f', 'Радіатор (новолат. radiātor — «випромінювач») — пристрій для розсіювання тепла у повітрі (випромінюванням та конвекцією), повітряний теплообмінник.'), 
('Carburetor', 'h', 'Карбюра́тор (від фр. carburateur, утвореного від carbure — «карбід») — пристрій, що використовується для отримання суміші повітря з паливом для двигуна внутрішнього згоряння.'), 
('Engine', 'j', 'Двигу́н, руші́й, мото́р (або силова установка) — енергосилова машина, що перетворює який-небудь вид енергії на механічну роботу.'), 
('Belt drive', 'k', '-'), 
('Gearbox', 'l', 'Механічна коробка передач (МКП) — механізм, призначений для східчастої зміни передавального відношення, в якому вибір передачі здійснюється оператором (водієм) вручну.'), 
('Axle,', 'm', 'Міст — конструктивний елемент автомобіля, що з*єднує між собою колеса однієї осі.'), 
('Cardan drive', 'n', 'Карданна передача (універсальний шарнір, шарнір Гука, універсальна муфта, механізм Кардана) — просторовий шарнірний механізм, що складається з центральної хрестовини і двох посаджених на кінці валів-вилок, що шарнірно сполучені з кінцями хрестовини.'), 
('Wheel drive', 'o', '-'), 
('Suspension', 'p', 'Підвіска автомобіля, або система підресорювання — сукупність деталей, вузлів і механізмів, які грають роль сполучної ланки між кузовом автомобіля і дорогою'), 
('Body', 'q', 'Ко́рпус (від лат. corpus — «тіло») — основна частина машини, механізму. Корпус легкового автомобіля — кузов на шасі, корпус вантажівки — шасі з кабіною.'), 
('Steering', 'g', 'Система кермування, кермове керування, рульове керування, кермове управління — сукупність елементів для спрямування руху транспортного засобу в бажаному напрямку за допомогою кермового колеса (кермування).'), 
('Brake system', 'r', 'Гальмівна́ систе́ма автомобі́ля (альтернативна форма: гальмова́ систе́ма автомобі́ля) — сукупність пристроїв, призначених для здійснення гальмування АТЗ, — поступового сповільнення чи зупинки транспортного засобу, обмеження його швидкості на спусках або для забезпечення його нерухомого стану під час стоянки.'), 
('Ignition system', 's', 'Система запалювання — це одна з головних систем в автомобілі, яка призначена для запалення робочої суміші в циліндрах двигунів внутрішнього згоряння.'), 
('Supply system', 't', '-'), 
('Starting system', 'u', '-'), 
('Cooling and heating system', 'v', '-'), 
('Air conditioner', 'w', 'Автомобільний кондиціонер - це система, яка дає можливість охолодити повітря, що потрапляє в салон машини з вулиці. '), 
('Glass cleaning system', 'i', 'Склоочи́сник (також «двірни́к») — це пристрій, що використовується для видалення крапель дощу (вологи) і бруду з вітрового скла автомобіля.'), 
('Filters', 'x', 'Фільтри захищають від забруднень вузли і системи в машині'),
('Tires', 'y', 'Автошина (побутові та жаргонні назви: скат, покришка або опона) — шина, яка встановлюється на ободі колеса автомобілю і заповнюється повітрям або іншим газом під тиском.')

insert into PriceChange(PriceId, DateChange, ManId, IdDet)
values(1, '2021-12-17', 3, 1), 
(1, '2021-12-16', 3, 1), 
(1, '2021-12-20', 3, 1),
/*вторая деливери*/
(2, '2021-12-16', 2, 2), 
(3, '2021-12-20', 2, 3), 
(4, '2021-12-16', 2, 2), 
(5, '2021-12-20', 2, 3),
(1, '2021-12-21', 2, 3)

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