/*	
	Author @Alexander MacDonald aemacdonald@wpi.edu
	Date @ 9/3/2022
	Assignment 2 CS3431 Professor Wong
*/

--2a

SELECT Building.city,
    CASE GROUPING(A.gallery)
        WHEN 1 THEN
            CASE GROUPING(Building.city)
                WHEN 1 THEN 'Grand Total'
                    ELSE 'Subtotal'
            END
        ELSE A.gallery
        END AS GALLERY,
    COUNT(title) AS COUNT
FROM (SELECT gallery, title, artworkID
      FROM Artwork
      WHERE year_ = 2009 OR
            year_ = 2013 OR
            year_ = 2019) A
    JOIN Gallery ON A.gallery = Gallery.gallery
    JOIN Building ON Gallery.building = Building.buildingName
GROUP BY ROLLUP( Building.city, A.gallery)
ORDER BY city,
    (CASE WHEN gallery = 'Subtotal'
        THEN 1 ELSE 0 END), gallery;
        
--2b

SELECT A2.artistID, Artist.firstName, Artist.lastName
FROM (SELECT artistID
      FROM Artwork
      WHERE year_= 2009 and year_ <> 2020) A2
    JOIN Artist ON A2.artistID = Artist.artistID
    UNION
SELECT A3.artistID, Artist.firstName, Artist.lastName
FROM (SELECT artistID
      FROM NewArt
      WHERE year_ = 2009 and year_ <> 2020) A3
    JOIN Artist ON A3.artistID = Artist.artistID
ORDER BY firstName, lastName;

--2c

SELECT title, gallery, year_, price
FROM Artwork
WHERE price > 75 AND materialsID IN
    (SELECT materialsID
     FROM Materials
     WHERE medium LIKE '%glass%')
ORDER BY title;

--2d

SELECT Artwork.year_ as YEAR,
       to_char(SUM(Artwork.price), '$999,990.99') as TotalArtValue,
       to_char(SUM(TicketPrice.ticketPrice), '$999,990.99') as TicketRevenue,
       to_char(SUM(Artwork.price) - SUM(TicketPrice.ticketPrice), '$999,990.99') as CustomerSurplus
FROM Artwork
    JOIN TicketPrice on Artwork.year_ = TicketPrice.year_
WHERE Artwork.chosen IS NOT NULL
GROUP BY Artwork.year_
ORDER BY Artwork.year_ DESC;

--2e
SELECT *
FROM (
    SELECT firstName, lastName, SUM(price) AS MaxDonatedValue
    FROM Artwork
        JOIN Artist ON Artwork.artistID = Artist.artistID
    GROUP BY firstName, lastName
    ORDER BY MaxDonatedValue DESC)
WHERE ROWNUM = 1;
