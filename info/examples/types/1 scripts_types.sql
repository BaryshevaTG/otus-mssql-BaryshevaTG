select * from sys.types;

---целый тип
--после 2147483647 преобразуются в decimal
SELECT 2147483647 / 2 AS Result1, 2147483649 / 2 AS Result2 ; 

---вещественный тип
drop table if exists example;
create table example(num1 numeric(5,3), num2 decimal(5,3), num3 numeric(5));
insert into example values(5.23365, 5.23362, 5.2332);
select * from example;

insert into example values(5.2, 5.2, 5.2);
select * from example;

---денежный тип
DECLARE @M MONEY = 1234, @D DECIMAL(6,2) = 1234
SELECT @M/$1000000 AS [MONEY] , @D/$1000000 AS [DECIMAL]

---Дата и время
DECLARE 
  @a DATETIME = '2015-05-12 23:59:59.996',
  @b DATETIME = '2015-05-12 23:59:59.998',
  @c DATETIME = '2015-05-12 23:59:59.999',

  @a2 DATETIME2 = '2015-05-12 23:59:59.996',
  @b2 DATETIME2 = '2015-05-12 23:59:59.998',
  @c2 DATETIME2 = '2015-05-12 23:59:59.999';
SELECT '2015-05-12 23:59:59.996' AS OrigValue, @a AS DatetimeValue, @a2 AS DatetimeValue2
UNION ALL
SELECT '2015-05-12 23:59:59.998', @b, @b2 AS DatetimeValue2
UNION ALL
SELECT '2015-05-12 23:59:59.999', @c, @c2 AS DatetimeValue2;

---- GUID
drop table if exists guid_table;

CREATE TABLE guid_table 
(	guid1 uniqueidentifier DEFAULT NEWSEQUENTIALID(),
	guid2 uniqueidentifier DEFAULT NEWID()
); 
insert into guid_table values(default, default);
select * from guid_table; 

---
drop table if exists rowvers;

CREATE TABLE rowvers (id int PRIMARY KEY, VerCol rowversion);
CREATE TABLE rowvers2 (id int PRIMARY KEY, timestamp);
insert into rowvers (id) values (1);
select * from rowvers; 

select * into rowvers3 from rowvers;

update rowvers set id = 4 where id = 1;