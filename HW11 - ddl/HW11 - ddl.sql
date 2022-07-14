--DDL 
--create database LibraryBase for project
CREATE DATABASE LibraryBase;
GO

---- create tables based on conceptual and logical models
USE LibraryBase;
GO

--create new schema for books
create schema book;

--create catalog publishing_house
CREATE TABLE book.publishing_house(
	house_id int not null identity(1, 1)  primary key,
	house_name nvarchar(50),
	owner nvarchar(100), 
)

--create catalog writers
CREATE TABLE book.writers(
	writer_id int not null identity(1, 1)  primary key,
	writer_name nvarchar(100)
)

--create catalog genre
CREATE TABLE book.genre(
	genre_id int not null identity(1, 1)  primary key,
	genre_name nvarchar(100)
)

--create catalog writers
CREATE TABLE book.books(
	book_number int not null identity(1, 1)  primary key,
	book_name nvarchar(50),
	count_pages int,
	genre_id int not null,
	category_by_age nvarchar(50),
	year_of_publish int,
	year_of_writing int,
	house_id int not null,
	writer_id int not null
)

create schema geo;

--create catalog city
CREATE TABLE geo.city(
	city_id int not null identity(1, 1)  primary key,
	region_id int not null,
	city_name  nvarchar(50)
	
)

--create catalog region
CREATE TABLE geo.region(
	region_id int not null identity(1, 1)  primary key,
	country_id int not null,
	region_name  nvarchar(50)
	
)

--create catalog region
CREATE TABLE geo.country(
	country_id int not null identity(1, 1)  primary key,
	country_name  nvarchar(50)
	
)

--create catalog readers
CREATE TABLE dbo.readers(
	reader_id int not null identity(1, 1)  primary key,
	reader_name  nvarchar(100),
	adress nvarchar(100),
	age int,
	city_id int not null
	
)

--create catalog readers
CREATE TABLE dbo.librarian(
	librarian_id int not null identity(1, 1)  primary key,
	librarian_name  nvarchar(100)
)

--create main table loans
CREATE TABLE dbo.loans(
	order_number uniqueidentifier DEFAULT NEWID(),
	librarian_id int not null,
	reader_id int not null,
	book_number int not null,
	return_period datetime2, --планова€ дата возврата
	date_start datetime2, --факт выдачи
	date_return datetime2 --факт возврата
)

-- books writers
ALTER TABLE book.books ADD  CONSTRAINT FK_books_ph FOREIGN KEY(writer_id)
REFERENCES book.writers (writer_id)
ON UPDATE CASCADE
ON DELETE CASCADE

-- books publishing_house
ALTER TABLE book.books ADD  CONSTRAINT FK_house_ph FOREIGN KEY(house_id)
REFERENCES book.publishing_house (house_id)
ON UPDATE CASCADE
ON DELETE CASCADE

-- books genre
ALTER TABLE book.books ADD  CONSTRAINT FK_genre_ph FOREIGN KEY (genre_id)
REFERENCES book.genre (genre_id)
ON UPDATE CASCADE
ON DELETE CASCADE

-- readers city
ALTER TABLE dbo.readers ADD  CONSTRAINT FK_city FOREIGN KEY (city_id)
REFERENCES geo.city (city_id)
ON UPDATE CASCADE
ON DELETE CASCADE

-- city region
ALTER TABLE geo.city ADD  CONSTRAINT FK_region FOREIGN KEY (region_id)
REFERENCES geo.region (region_id)
ON UPDATE CASCADE
ON DELETE CASCADE

-- region country
ALTER TABLE geo.region ADD  CONSTRAINT FK_country FOREIGN KEY (country_id)
REFERENCES geo.country (country_id)
ON UPDATE CASCADE
ON DELETE CASCADE

-- loans librarian
ALTER TABLE dbo.loans ADD  CONSTRAINT FK_loans_lib FOREIGN KEY (librarian_id)
REFERENCES dbo.librarian (librarian_id)

-- loans readers
ALTER TABLE dbo.loans ADD  CONSTRAINT FK_loans_rdr FOREIGN KEY (reader_id)
REFERENCES dbo.readers (reader_id)

-- loans books
ALTER TABLE dbo.loans ADD  CONSTRAINT FK_loans_bks FOREIGN KEY (book_number)
REFERENCES book.books (book_number)


--ќграничение на ввод категории
ALTER TABLE book.books ADD CONSTRAINT check_category CHECK (category_by_age IN ('18+', 'детска€', 'подросткова€'));

--ввод издательства только прописными
ALTER TABLE book.publishing_house ADD CONSTRAINT check_uppercase CHECK (house_name = UPPER(house_name));

--ввод издательства только прописными
ALTER TABLE book.writers ADD CONSTRAINT check_upper CHECK (writer_name = UPPER(writer_name));

--дата возврата больше даты выдачи
ALTER TABLE dbo.loans ADD CONSTRAINT date_return_compare CHECK (date_return >= date_start);

--ограничение на возраст читател€: в базу внос€т при достижении 14 лет
ALTER TABLE dbo.readers ADD CONSTRAINT check_age CHECK (age >= 14);