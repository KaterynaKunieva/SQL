/*1. �������� �� ����� SQL*/

create database [Internet-shop] /*���� �����*/
use [Internet-shop]

create table Good( /*�����*/
Id int identity, /*���*/
[Name] varchar(30), /*�����*/
Price money, /*����*/
unit varchar(10), /*������� �����*/
Primary key(Id) 
);

create table Discount(/*������*/
Id int identity(1,1), /*���*/
[Percentage] float, /*�������*/
primary key(Id)
);

create table Client(/*�볺��*/
Id int identity(1,1), /*���*/
Surname varchar(20), /*�������*/
[Name] varchar(20), /*��'�*/
MiddleName varchar(20), /*��-�������*/
Adress varchar(50), /*������*/
Phone varchar(13), /*�������*/
[E-mail] varchar(30), /*�����*/
IdDiscount int default 1, /*�������� ������: 1 - ���� ������, 2 - � ������*/
primary key(Id), 
foreign key(IdDiscount) references Discount(Id)
);

create table Sale(/*�����*/
Id int identity(1,1), /*���*/
IdClient int, /*�볺��*/
DateSale date default getdate(), /*���� �������*/
DateDelivery date default getdate() + 3, /*���� ��������*/
Amount money default 0, /*������� ������*/
primary key(Id), 
foreign key(IdClient) references Client(Id) 
);

create table GoodInSale(/*������ � �����*/
Id int identity(1,1), /*���*/
IdGood int, /*�����*/
Number int, /*�������*/
IdSale int, /*���� �����*/
primary key(Id), 
foreign key(IdGood) references Good(Id), 
foreign key(IdSale) references Sale(Id)
); 

create table Storage(/*�����*/
Id int identity(1,1), /*���*/
IdGood int, /*�����*/
Number int, /*�������*/
primary key(Id), 
foreign key(IdGood) references Good(Id)
);



/*2.1. ������ ��� � �� (Insert).*/
insert into Good([Name], Price, unit)
values('�������', 2000, '��'), 
('����', 10, '��'), 
('����', 11, '�'), 
('�����', 20, '��'), 
('��������', 15, '��'), 
('������', 30, '�')

insert into Discount([Percentage])
values(0), 
(2)

insert into Client(Surname, [Name], MiddleName, Adress, Phone, [E-mail])
values('��������', '����', '��������', '����������, 6', '+380980975643', 'ivanenko@gmail.com'), 
('��������', '�����', '��������', '����������, 9', '+380506784635', 'petrenko@gmail.com'), 
('�������', '������', '����������', '������������, 11', '+380978675463', 'vasyluk@ukr.net')

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


/*4.1. ��� �������������� ������� ������ �� ����� �������� �����*/
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
		rollback tran print '³���� ����������: �� ����� ����������� ������'
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

/*4.4. ����� �������� ��� ��������� � GoodInSale ������� ���������: */
go
create procedure insertInGIS(@IdSale int, @IdGood int, @Number int)
as
insert into GoodInSale(IdSale, IdGood, Number)
values(@IdSale, @IdGood, @Number)

/*��������� ��������� - �������� ����� � ������� GoodInSale*/
exec insertInGIS 1, 2, 2 
exec insertInGIS 1, 1, 5
exec insertInGIS 2, 3, 7

/*��������*/
select *
from GoodInSale
select *
from Storage



/*����������� �������� 2*/
/*2.2. ����� �������� 1 ����� � �������� Update �� 1 ����� � �������� Delete */
/*������������ �������� ������� 0*/
update Storage 
set Number = 0
where IdGood = 6
/*��������� ������, �� ������� 0*/
delete Storage 
where Number = 0
/*��������*/
select *
from Storage




/*3. �������� ������ �� ������ �����*/
-- ������� �����
select (c.[Name] + ' ' + c.MiddleName + ' ') as 'Client', c.Phone
from Client c

-- ����� � �����������
select count(s.IdGood) as 'ʳ������ ����������� �� �����'
from Storage s

-- ����� � ������
select count(s.IdGood) as 'ʳ������ �������� ������ �� �����'
from Storage s
where s.Number != 0 

-- ����� � �������� Like
select g.[Name]
from Good g
where g.unit like '��'

-- ������ � ������ 
select s.Id, Day(s.DateSale) as '����', Month(s.DateSale) as '̳����', Year(s.DateSale) as 'г�'
from Sale s
where s.Id = 3

-- ����� �� ������ � ���� ������� (inner join)
select g.Name as '����� ������', s.Number 'ʳ������ �� �����'
from Storage s
inner join Good g on g.Id=s.IdGood

-- ����� �� ������ � ���� ������� (left ��� right)
select (c.[Name] + ' ' + c.MiddleName + ' ') as 'Client', s.Id as '����� ������'
from Client c
left join Sale s on c.Id = s.IdClient 

-- ������������ ����� 
select g.Name as '�����', s.Id as '�����', Sum(gis.Number) as 'ʳ������ � �����'
from GoodInSale as gis 
inner join Good as g on g.Id = gis.IdGood 
inner join Sale as s on s.Id = gis.IdSale
group by g.Name, s.Id

/*4. ��������*/
/*4.1. (�����)*/
/* ���� �������� ���� */

/*4.2. ������������� - �� ������ � ������ ����������� � �������*/
go
create view Goods_In_delivery 
as
select g.Id as IdGood, g.Name as 'Good', s.Id as 'Sale', gis.Number as 'Goods in sale', st.Number as 'Number in storage'
from Good g
inner join Storage st on st.IdGood = g.Id 
inner join GoodInSale gis on gis.IdGood = g.Id
inner join Sale s on s.Id = gis.IdSale

/*4.3. �� ����� ������������� �������� ����� - ��� � ������������� � ���� ���� ����� 50*/
select *
from Goods_In_delivery gid 
inner join Good g on gid.IdGood = g.Id
where g.Price>50

/*4.4. ��������� ����� ���� �������� ����*/
/*��������� - ��������� ���������� ���� ��� �볺��� + �������� �� ���� ���������� ����� 5000 + ��������� �볺��� ������*/
go
create procedure ToSaleDiscount(@IdSale int)
as
begin
	declare /*����*/
		@IdClient int, /*����, ����� ������� ������ ����������*/
		@Total money, /*��������� ���� ����������*/
		@Discount float /*������*/
	select @IdClient = c.Id /*�볺��, ����'������ �� �������� ����������*/
					from Client as c
					inner join Sale as s on s.IdClient = c.Id /*������� ����������*/
					where s.Id = @IdSale
	select @Total = Sum(gis.Number*g.Price) /*���������� ���� ������ ��� ������*/ 
						from Sale as s /*������� ����������*/
						inner join GoodInSale as gis on gis.IdSale = s.Id /*������ � ���������, ��� �������*/
						inner join Good as g on g.Id = gis.IdGood /*�����, ��� ����*/
						where s.Id = @IdSale/*���� �� �������� ����������*/
						group by s.Id
	/*���� ������� � ��������� �� ���� �� ����������� ����*/
	if @Total>5000 
	begin
		update Client 
		set IdDiscount = 2
		where Id = @IdClient
	end;

	/*�� ��������� ��������� ������, ���� �������� �볺�� ������ ����� �� �� 5000 ���*/
	update Client 
	set IdDiscount = case 
	when IdDiscount = 2 then 2 
	else 1 end

	/*������� ������*/
	select @Discount = d.[Percentage]/cast(100 as float) /*���������� �������*/
						from Discount as d /*������� � ���������*/
						inner join Client as c on c.IdDiscount = d.Id /*�� �볺��� ����'���� ������ ���*/
						where c.Id = @IdClient /*�� ��������� �볺���*/
	set @Total = @Total * (1 - @Discount)
	
	/*��������� ���� �� ����������*/
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

/*��������� �������� ��� �� �������, ���� ������ ����� ���� ����� 5000*/
insert into Sale(IdClient)
values(1) /*�� ��� �� ������ ��������� �볺���*/
select * from Sale
exec insertInGIS 4, 2, 2 
exec ToSaleDiscount 4

select *
from Sale
select *
from Client

/*������� - ������� ������� ������ �� ����� ����*/
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