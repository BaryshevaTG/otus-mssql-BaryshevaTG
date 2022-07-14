USE LibraryBase
GO

SELECT*FROM geo.city

SET IDENTITY_INSERT geo.country ON

INSERT INTO geo.country (country_id, country_name)
VALUES (1, 'Россия'), (2, 'Молдова'), (3, 'Беларусь'), (4, 'Ураина'), (5, 'Литва')

SET IDENTITY_INSERT geo.country OFF

SET IDENTITY_INSERT geo.region ON

INSERT INTO geo.region (region_id, country_id, region_name)
VALUES (1, 1, 'Санкт-Петербург'), (2, 3, 'Минская область'), (3, 1, 'Москва'), (4, 1, 'Хабаровский край'), (5, 1, 'Краснодарский край')

SET IDENTITY_INSERT geo.region OFF

SET IDENTITY_INSERT geo.city ON

INSERT INTO geo.city (city_id, region_id, city_name)
VALUES (1, 1, 'Санкт-Петербург'), (2, 2, 'Минск'), (3, 3, 'Москва'), (4, 4, 'Хабаровск'), (5, 4, 'Комсомольск-на-Амуре')

SET IDENTITY_INSERT geo.city OFF
