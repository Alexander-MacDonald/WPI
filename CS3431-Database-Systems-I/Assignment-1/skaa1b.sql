-- Author @Alexander MacDonald aemacdonald@wpi.edu
-- Date @ 8/28/2022
-- Assignment 1 CS3431 Prof Wong
/* Connection Test
SELECT *
FROM Artwork;

SELECT *
FROM Artist;

SELECT *
FROM Materials;

SELECT *
FROM Gallery;

SELECT *
FROM TicketPrice;
*/
-- 2a
SELECT firstName || ' ' || lastName AS ArtistName, city || ', ' || state_ AS Location
FROM Artist
WHERE state_ = 'MA' OR state_ = 'CT'
ORDER BY state_, city, lastName;

-- 2b
UPDATE TicketPrice SET TicketPrice = TicketPrice + 10
WHERE year_ >= 2013 AND year_ <= 2021;

DELETE FROM TicketPrice
WHERE year_ = 2022;

-- 2c
SELECT building, gallery, title, price, to_char(purchaseDate, 'MON DD, YYYY') AS PurchaseDate
FROM Artwork 
NATURAL JOIN Gallery
WHERE purchaseDate IS NOT NULL OR gallery = 'Sculpture Garden'
ORDER BY building, gallery, title;

-- 2d
SELECT firstName, lastName, title, medium_ AS medium, price * 2 AS PandemicPrice, gallery
FROM Artwork
     JOIN Artist ON Artwork.artistID = Artist.artistID
     JOIN Materials ON Artwork.materialsID = Materials.materialsID
WHERE price >= 100 AND price <= 200 AND category_ = 'Oil' AND (gallery = 'Gund' OR gallery = 'Walker')
ORDER BY lastName, firstName, title;

--2e

SELECT DISTINCT Artwork.gallery, category_
FROM Artwork
	 JOIN Materials ON Artwork.materialsID = Materials.materialsID
	 JOIN Gallery ON Artwork.gallery = Gallery.gallery
WHERE building = 'Stein Conservatory'
ORDER BY gallery, category_;