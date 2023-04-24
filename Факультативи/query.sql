/*1. Створити БД мовою SQL*/

create database electives
use electives

/*студент*/
create table Student( 
Id int identity(1,1) not null, /*код*/ 
[Name] varchar(20), /*ім'я*/
Surname varchar(20), /*прізвище*/
MiddleName varchar(20), /*по-батькові*/
Adress varchar(100), /*адреса*/
Phone varchar(20), /*телефон*/
primary key (Id) /*ключ*/
);


/*предмет*/
create table Subj(
Id int identity(1,1) not null, /*код*/
[Name] varchar (50), /*назва*/
primary key (Id) /*ключ*/
);


/*навчальний план*/
create table Curriculum(
Semester int identity(1,1) not null, /*семестер*/
IdSubj int, /*код предмета*/
Lecture int, /*обсяг лекцій*/
Practise int, /*обсяг практик*/
Labs int, /*обсяг лаб*/
primary key(Semester), 
foreign key(IdSubj) references Subj(Id) 
); 

/*успішність*/
create table Progress(
IdStud int, 
IdSubj int, 
Semester int, 
Grade int, 
foreign key(IdStud) references Student(Id), 
foreign key(IdSubj) references Subj(Id), 
foreign key(Semester) references Curriculum(Semester)
);



/*2. Внести дані в БД (Insert).*/
insert into Subj([Name])
values('Математика'), 
('Програмування'), 
('Бази даних'), 
('Мистецтво')

insert into Student(Surname, [Name],  MiddleName, Adress, Phone)
values('Іваненко', 'Іван', 'Іванович', 'вул. Івановська, буд. 3, кв. 6', '+380507689768'), 
('Петренко', 'Петро', 'Петрович', 'вул. Петровська, буд. 6, кв. 3', NULL), 
('Сидоренко', 'Федір', 'Федорович', 'вул. Сидоренків, буд. 15, кв. 123', '+380666578904')

insert into Curriculum(IdSubj, Lecture, Practise, Labs)
values(1, 10, 15, 8), 
(2, 15, 10, 20), 
(3, 12, 12, 12), 
(4, 8, 20, 0)

insert into Progress(IdStud, IdSubj, Semester, Grade)
values(1, 1, 1, 10), 
(1, 2, 1, 10), 
(1, 3, 1, 12), 
(1, 4, 1, 8), 
(2, 1, 1, 11), 
(2, 2, 1, 9), 
(2, 3, 1, 8), 
(2, 4, 1, 12), 
(3, 1, 1, 7), 
(3, 2, 1, 9), 
(3, 3, 1, 10), 
(3, 4, 1, 11), 
(1, 1, 2, 9), 
(1, 2, 2, 11), 
(1, 3, 2, 10), 
(1, 4, 2, 12), 
(3, 1, 3, 8), 
(3, 2, 3, 10), 
(3, 3, 3, 11), 
(3, 4, 3, 10), 
(2, 2, 4, 12)

/*створити 1 запит з командою Update та 1 запит з командою Delete*/
update Progress 
set Grade = '12' 
where IdStud = 1 and IdSubj = 1
/*перевірка: */ select * from Progress 

/*додамо та видалимо непотрібний запис*/
insert into Progress(IdStud, IdSubj, Semester, Grade)
values(2, 2, 4, 12)

delete from Progress 
where IdStud = 2 and Semester = 4
/*перевірка: */ select * from Progress 



/*3. Створити запити на вибірку даних*/

/*простий запит*/
select *
from Curriculum

/*запит з обчисленням*/
select Count(Id) as 'Всього вчиться'
from Student

select c.Semester, Sum(c.Labs+c.Practise+c.Lecture) as 'Всього годин'
from Curriculum as c
group by c.Semester

/*запит з умовою*/
select (s.Surname + ' ' + s.Name + ' ' + s.MiddleName) as 'Student', su.Name, p.Grade
from Progress as p
inner join Student as s on p.IdStud=s.Id
inner join Subj as su on p.IdSubj = su.Id
where p.Grade>=10 and p.Grade<=12

/*запит з командою LIKE*/
select s.Name
from Subj as s
where s.Name Like '%з%'

/*запит, робота з датами (Day(), Month(), Year())*/
alter table Student
add birthday date; 

	/*додамо дні народження*/
	update Student
	set birthday = '2001-08-12'
	where Id = 1
	update Student
	set birthday = '2000-01-01'
	where Id = 2
	update Student
	set birthday = '2001-09-16'
	where Id = 3

select s.Name, Day(s.birthday) as 'День', Month(s.birthday) as 'Місяць', Year(s.birthday) as 'Рік'
from Student as s

/*запит на вибірку з двох таблиць INNER*/
select s.Name, c.Labs, c.Lecture, c.Practise
from Subj as s
inner join Curriculum as c on s.Id = c.IdSubj

/*запит на вибірку з двох таблиць LEFT*/
select st.Name, AVG(p.Grade) as 'Average grade'
from Student as st
left join Progress as p on st.Id=p.IdStud
group by st.Name

/*групувальний запит*/
select s.Name, Sum(c.Labs) as 'Сума годин відведених на лабороторні роботи'
from Curriculum as c
right join Subj as s on c.IdSubj = s.Id
group by s.Name
order by 'Сума годин відведених на лабороторні роботи' DESC 

/*4. Створити*/
/*трігер*/
GO
CREATE TRIGGER insert_student ON Student after insert
as
begin
	insert into Progress(Semester, Grade, IdStud, IdSubj)
	Select 1, NULL, (select Id from inserted), S.Id from Subj S; 
end; 

insert into Student(Name, Surname, MiddleName, Adress, Phone, birthday)
values('Василь', 'Всильківський', 'Васильович', 'Васильківська, 1', '+380505674325', '2001-10-18')

select*
from Student
select *
from Progress

/*представлення*/
go 
create view StudentsProgressesSubject 
as
select st.Name+st.Surname+st.MiddleName as 'Student', s.Name as 'Subject', p.Grade as 'Grade' 
from Progress as p 
inner join Student as st on p.IdStud = st.Id
inner join Subj as s on p.IdSubj = s.Id
where p.Semester = 1

/*на основі представлення створити запит*/
select *
from StudentsProgressesSubject
where Grade<10

/*процедура*/
go
create procedure insert_curriculum 
	@IdSubj int, 
	@Lecture int,
	@Practise int,
	@Labs int
as 
begin
	insert into Curriculum(IdSubj, Lecture, Practise, Labs)
	values(@IdSubj, @Lecture, @Practise, @Labs)
end; 

exec insert_curriculum 1, 15, 10, 8
select *
from Curriculum

/*Функція*/
go
create function averageGradeBySemester(@IdSemester int, @IdStudent int)
returns int
as
begin
	declare @rez int; 
	select @rez = AVG(p.Grade) 
	from Progress as p
	where p.IdStud = @IdStudent and p.Semester = @IdSemester
	return @rez
end; 

select dbo.averageGradeBySemester(2, 1)