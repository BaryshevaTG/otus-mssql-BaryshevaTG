--createindexes for db
USE LibraryBase
GO

-- ������� �������������� �������
CREATE FULLTEXT CATALOG FullText_Cat
WITH ACCENT_SENSITIVITY = ON
AS DEFAULT
AUTHORIZATION [dbo]
GO

--������� ��� ������ ���� �� �������� 
CREATE FULLTEXT INDEX ON book.books(book_name LANGUAGE Russian)
KEY INDEX PK__books__1502D76B490A35E1 -- ��������� ����
ON (FullText_Cat)
WITH (
  CHANGE_TRACKING = AUTO,
  STOPLIST = SYSTEM
);
GO

--������� ��� ������ ���� �� ����� 
CREATE FULLTEXT INDEX ON book.genre(genre_name LANGUAGE Russian)
KEY INDEX PK__genre__18428D42E469CDA2 -- ��������� ����
ON (FullText_Cat)
WITH (
  CHANGE_TRACKING = AUTO,
  STOPLIST = SYSTEM
);
GO

SELECT *
FROM book.books 
WHERE CONTAINS (book_name, 'FORMSOF(INFLECTIONAL, "���������")')  
GO


SELECT *
FROM book.books 
LEFT JOIN book.genre ON books.genre_id = genre.genre_id
WHERE 
CONTAINS (book_name, 'FORMSOF(INFLECTIONAL, "�����")')  
and
CONTAINS (genre_name, 'FORMSOF(INFLECTIONAL, "��������������")')  
GO



