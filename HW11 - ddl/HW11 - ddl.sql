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

--create catalog writers
CREATE TABLE book.books(
	book_number int not null identity(1, 1)  primary key,
	book_name nvarchar(50),
	count_pages int,
	genre nvarchar(50),
	category_by_age nvarchar(50),
	year_of_publish int,
	year_of_writing int,
	house_id int not null,
	writer_id int not null
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

--Ограничение на ввод категории
ALTER TABLE book.books ADD CONSTRAINT check_category CHECK (genre IN ('18+', 'детская', 'подростковая'));

--ввод издательства только прописными
ALTER TABLE book.publishing_house ADD CONSTRAINT check_uppercase CHECK (house_name = UPPER(house_name));

--ввод издательства только прописными
ALTER TABLE book.writers ADD CONSTRAINT check_upper CHECK (writer_name = UPPER(writer_name));

--индексы для поиска книг по названию и жанру
CREATE INDEX idx_book_name on book.books (book_name);
CREATE INDEX idx_book_genre on book.books (genre);