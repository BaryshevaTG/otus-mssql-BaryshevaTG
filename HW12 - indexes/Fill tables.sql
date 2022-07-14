USE LibraryBase
GO

SELECT*FROM geo.city

SET IDENTITY_INSERT geo.country ON

INSERT INTO geo.country (country_id, country_name)
VALUES (1, '������'), (2, '�������'), (3, '��������'), (4, '������'), (5, '�����')

SET IDENTITY_INSERT geo.country OFF

SET IDENTITY_INSERT geo.region ON

INSERT INTO geo.region (region_id, country_id, region_name)
VALUES (1, 1, '�����-���������'), (2, 3, '������� �������'), (3, 1, '������'), (4, 1, '����������� ����'), (5, 1, '������������� ����')

SET IDENTITY_INSERT geo.region OFF

SET IDENTITY_INSERT geo.city ON

INSERT INTO geo.city (city_id, region_id, city_name)
VALUES (1, 1, '�����-���������'), (2, 2, '�����'), (3, 3, '������'), (4, 4, '���������'), (5, 4, '�����������-��-�����')

SET IDENTITY_INSERT geo.city OFF
