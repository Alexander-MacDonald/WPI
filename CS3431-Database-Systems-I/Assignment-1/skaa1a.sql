-- Author @Alexander MacDonald aemacdonald@wpi.edu
-- Date @ 8/28/2022
-- Assignment 1 CS3431 Prof Wong
ALTER SESSION SET NLS_DATE_FORMAT = 'MM/DD/YYYY';

DROP TABLE Artwork;
DROP TABLE Artist;
DROP TABLE Materials;
DROP TABLE Gallery;
DROP TABLE TicketPrice;

CREATE TABLE Artist (
    artistID NUMBER(5) NOT NULL,
    firstName VARCHAR2(20),
    lastName VARCHAR2(25),
    city VARCHAR2(20),
    state_ CHAR(2),
	--Primary Key
    CONSTRAINT ARTIST_PK PRIMARY KEY (artistID),
	--State Restriction (1BV)
	CONSTRAINT ARTIST_STATE__R1 CHECK
		(UPPER(state_) = 'MA' OR
		 UPPER(state_) = 'NH' OR
		 UPPER(state_) = 'VT' OR
		 UPPER(state_) = 'CT' OR
		 UPPER(state_) = 'ME' OR
		 UPPER(state_) = 'RI' OR
		 UPPER(state_) = 'NY' OR
		 UPPER(state_) = 'CA' OR
		 UPPER(state_) = 'OR' OR
		 UPPER(state_) = 'WA')
);

CREATE TABLE Materials (
    materialsID NUMBER(5) NOT NULL,
    category_ VARCHAR2(20),
    medium_ VARCHAR2(50),
	--Primary Key
	CONSTRAINT MATERIALS_PK PRIMARY KEY (materialsID)
);

CREATE TABLE Gallery (
	gallery VARCHAR2(20) NOT NULL,
	building VARCHAR(20),
	--Primary Key
	CONSTRAINT GALLERY_PK PRIMARY KEY (gallery),
	--No empty strings (1BVI)
	CONSTRAINT GALLERY_BUILDING_R1 CHECK (building <> '')
);

CREATE TABLE TicketPrice (
	year_ NUMBER(4) NOT NULL,
	ticketPrice NUMBER(3),
	--Primary Key
	CONSTRAINT TICKETPRICE_PK PRIMARY KEY (year_),
	--TP >= 50 (1BVII)
	CONSTRAINT TICKETPRICE_TICKETPRICE_R1 CHECK (ticketPrice >= 50)
);

CREATE TABLE Artwork (
    year_ NUMBER(4) NOT NULL,
    artworkID NUMBER(5) NOT NULL,
    artistID NUMBER(5),
    title VARCHAR2(75),
    materialsID NUMBER(5),
    price NUMBER(5),
    chosen NUMBER(3),
    purchased CHAR(1),
    purchaseDate DATE,
    gallery VARCHAR2(20),
    --Primary Key
	CONSTRAINT ARTWORK_PK PRIMARY KEY (year_, artworkID),
	--Foreign Keys to 4 other tables (1BIII)
	CONSTRAINT ARTWORK_ARTISTID_FK FOREIGN KEY (artistID) REFERENCES Artist(artistID)
		ON DELETE CASCADE,
	CONSTRAINT ARTWORK_MATERIALSID_FK FOREIGN KEY (materialsID) REFERENCES Materials(materialsID)
		ON DELETE CASCADE,
	CONSTRAINT ARTWORK_GALLERY_FK FOREIGN KEY (gallery) REFERENCES Gallery(gallery)
		ON DELETE CASCADE,
	CONSTRAINT ARTWORK_YEAR_FK FOREIGN KEY (year_) REFERENCES TicketPrice(year_)
		ON DELETE CASCADE,
	--n or y Purchased Restriction (1BIV)
	CONSTRAINT ARTWORK_PURCHASED_R1 CHECK (purchased = 'y' OR purchased = 'n')
);

-- Artist Data Entry
insert into Artist values(15, 'Brady', 'Addis', 'Pawtucket', 'RI');
insert into Artist values(35, 'Lilith', 'Aldey', 'Boston', 'MA');
insert into Artist values(70, 'Remy', 'Archdacon', 'Newport', 'RI');
insert into Artist values(90, 'Athena', 'Asteridge', 'Pawtucket', 'RI');
insert into Artist values(95, 'Sienna', 'Aylestone', 'Smithfield', 'CT');
insert into Artist values(120, 'Cassandra', 'Batkyn', 'Providence', 'RI');
insert into Artist values(135, 'Rosa', 'Beckingham', 'Kingston', 'RI');
insert into Artist values(140, 'Stella', 'Beckingham', 'Kingston', 'RI');
insert into Artist values(160, 'Arabella', 'Biatt', 'Narragansett', 'RI');
insert into Artist values(190, 'Samantha', 'Blinken', 'Newport', 'RI');
insert into Artist values(210, 'Wiley', 'Brewes', 'Newport', 'RI');
insert into Artist values(255, 'Pablo', 'Cain', 'Taunton', 'MA');
insert into Artist values(270, 'Blaire', 'Cantu', 'Kingston', 'RI');
insert into Artist values(315, 'Roland', 'Cheng', 'Kingston', 'RI');
insert into Artist values(330, 'Jordan', 'Cochran', 'Pawtucket', 'RI');
insert into Artist values(345, 'Chloe', 'Conner', 'Kingston', 'RI');
insert into Artist values(365, 'Joselyn', 'Cooper', 'Scituate', 'RI');
insert into Artist values(400, 'Jazmine', 'Daniels', 'Taunton', 'MA');
insert into Artist values(455, 'Jarod', 'Drake', 'Fall River', 'MA');
insert into Artist values(485, 'Ellis', 'Everett', 'Kingston', 'RI');
insert into Artist values(500, 'Jarod', 'Ferguson', 'New Haven', 'CT');
insert into Artist values(520, 'Peyton', 'Fischer', 'South Kingston', 'RI');
insert into Artist values(535, 'Jack', 'Franco', 'Fall River', 'MA');
insert into Artist values(540, 'Jewel', 'Franklin', 'Kingston', 'RI');
insert into Artist values(570, 'Chad', 'Garcia', 'Kingston', 'RI');
insert into Artist values(575, 'Rylie', 'Gates', 'Kingston', 'RI');
insert into Artist values(630, 'Jamal', 'Gonzales', 'South Kingston', 'RI');
insert into Artist values(635, 'Paris', 'Goodwin', 'Pawtucket', 'RI');
insert into Artist values(645, 'Rosa', 'Graves', 'Hartford', 'CT');
insert into Artist values(650, 'Stella', 'Gray', 'Newport', 'RI');
insert into Artist values(660, 'Kelly', 'Griffin', 'Kingston', 'RI');
insert into Artist values(665, 'Sophia', 'Grimes', 'South Kingston', 'RI');
insert into Artist values(695, 'Magnolia', 'Hamilton', 'South Kingston', 'RI');
insert into Artist values(700, 'Kai', 'Hammond', 'Kingston', 'RI');
insert into Artist values(740, 'Peyton', 'Henry', 'South Kingston', 'RI');
insert into Artist values(745, 'Lexi', 'Herman', 'Newport', 'RI');
insert into Artist values(780, 'Lexi', 'Hogan', 'Warwick', 'RI');
insert into Artist values(810, 'Gloria', 'Jacobs', 'South Kingston', 'RI');
insert into Artist values(815, 'Carmen', 'Jefferson', 'Narragansett', 'RI');
insert into Artist values(820, 'Brittany', 'Jenkins', 'Franklin', 'MA');
insert into Artist values(825, 'Mario', 'Jenkins', 'Pawtucket', 'RI');
insert into Artist values(845, 'Diana', 'Jones', 'Boston', 'MA');
insert into Artist values(855, 'Blaire', 'Jordan', 'Pawtucket', 'RI');
insert into Artist values(875, 'Johanna', 'Kane', 'Exeter', 'RI');
insert into Artist values(900, 'Thor', 'Kent', 'Cambridge', 'MA');
insert into Artist values(905, 'Gwen', 'Key', 'South Kingston', 'RI');
insert into Artist values(915, 'Emma', 'Kirk', 'Smithfield', 'CT');
insert into Artist values(930, 'Mariah', 'Kramer', 'Kingston', 'RI');
insert into Artist values(935, 'Adrianna', 'Lake', 'Warwick', 'RI');
insert into Artist values(940, 'Thaddeus', 'Lam', 'Newport', 'RI');
insert into Artist values(945, 'Jarod', 'Lambert', 'Hartford', 'CT');
insert into Artist values(955, 'Millie', 'Lang', 'Kingston', 'RI');
insert into Artist values(975, 'Malia', 'Le', 'Wrentham', 'MA');
insert into Artist values(980, 'Madeline', 'Leblanc', 'Pawtucket', 'RI');
insert into Artist values(1000, 'Stevie', 'Li', 'Pawtucket', 'RI');
insert into Artist values(1030, 'Brigham', 'Lopez', 'Newport', 'RI');
insert into Artist values(1040, 'Nadia', 'Luna', 'Dartmouth', 'MA');
insert into Artist values(1085, 'Marshall', 'Martinez', 'South Kingston', 'RI');
insert into Artist values(1090, 'Karla', 'Mason', 'Kingston', 'RI');
insert into Artist values(1105, 'Timothy', 'Maxwell', 'New Haven', 'CT');
insert into Artist values(1120, 'Klaus', 'McClure', 'Pawtucket', 'RI');
insert into Artist values(1150, 'Trinity', 'Melendez', 'Kingston', 'RI');
insert into Artist values(1180, 'Jarod', 'Miles', 'Portsmouth', 'ME');
insert into Artist values(1195, 'Laura', 'Molina', 'Scituate', 'RI');
insert into Artist values(1205, 'Jaylee', 'Moore', 'Providence', 'RI');
insert into Artist values(1290, 'Ruby', 'Olson', 'Boston', 'MA');
insert into Artist values(1300, 'Cassandra', 'Ortega', 'Kingston', 'RI');
insert into Artist values(1310, 'Sierra', 'Osborne', 'Cambridge', 'MA');
insert into Artist values(1325, 'Sherwin', 'Pace', 'Worcester', 'MA');
insert into Artist values(1340, 'Mariah', 'Page', 'Pawtucket', 'RI');
insert into Artist values(1360, 'Nadia', 'Patrick', 'Pawtucket', 'RI');
insert into Artist values(1370, 'Paloma', 'Pearson', 'Warwick', 'RI');
insert into Artist values(1395, 'Nancy', 'Perry', 'Pawtucket', 'RI');
insert into Artist values(1400, 'Naomi', 'Perry', 'Pawtucket', 'RI');
insert into Artist values(1420, 'Mackenzie', 'Pierce', 'Narragansett', 'RI');
insert into Artist values(1495, 'Elliott', 'Rollins', 'Middletown', 'RI');
insert into Artist values(1525, 'Leif', 'Rush', 'Narragansett', 'RI');
insert into Artist values(1530, 'Sawyer', 'Russell', 'Warwick', 'RI');
insert into Artist values(1535, 'Adrian', 'Ryan', 'Exeter', 'RI');
insert into Artist values(1580, 'Arabella', 'Savage', 'Exeter', 'RI');
insert into Artist values(1590, 'Delaney', 'Schmidt', 'Cambridge', 'MA');
insert into Artist values(1600, 'Laurence', 'Serrano', 'Providence', 'RI');
insert into Artist values(1630, 'Renata', 'Sheppard', 'Pawtucket', 'RI');
insert into Artist values(1650, 'Camilla', 'Smith', 'South Kingston', 'RI');
insert into Artist values(1655, 'Simone', 'Solomon', 'Pawtucket', 'RI');
insert into Artist values(1680, 'Johanna', 'Stein', 'Pawtucket', 'RI');
insert into Artist values(1695, 'Jarod', 'Sutton', 'Warwick', 'RI');
insert into Artist values(1720, 'Merrick', 'Thornton', 'Kingston', 'RI');
insert into Artist values(1750, 'Mara', 'Trujillo', 'Wrentham', 'MA');
insert into Artist values(1810, 'Cecil', 'Ward', 'Kingston', 'RI');
insert into Artist values(1825, 'Emilio', 'Waters', 'Scituate', 'RI');
insert into Artist values(1835, 'Riley', 'Watts', 'Greenwich', 'CT');
insert into Artist values(1855, 'Coraline', 'Weeks', 'Franklin', 'MA');
insert into Artist values(1865, 'Reese', 'Welch', 'Wrentham', 'MA');
insert into Artist values(1870, 'Lisa', 'Wong', 'Pawtucket', 'RI');
insert into Artist values(1875, 'Winslow', 'Wu', 'South Kingston', 'RI');
insert into Artist values(1880, 'Abner', 'Wumbar', 'Greenville', 'RI');
insert into Artist values(1885, 'Paris', 'Wumbar', 'Greenwich', 'CT');

-- Materials Data Entry

insert into Materials values(5, 'Acrylic', 'acrylic');
insert into Materials values(60, 'Drawing', 'pencil on paper');
insert into Materials values(65, 'Encaustic', 'encaustic');
insert into Materials values(75, 'Etching', 'etching');
insert into Materials values(90, 'Etching', 'solar plate etching');
insert into Materials values(100, 'Fabric', 'fabric');
insert into Materials values(110, 'Fabric', 'fiber');
insert into Materials values(130, 'Glass', 'glass');
insert into Materials values(145, 'Jewelry', 'ceramic, copper');
insert into Materials values(190, 'Jewelry', 'porcelain, sterling');
insert into Materials values(195, 'Jewelry', 'raku leaves, pearls, glass, water');
insert into Materials values(210, 'Jewelry', 'silver, glass');
insert into Materials values(215, 'Jewelry', 'silver, porcelain');
insert into Materials values(230, 'Linocut', 'linocut');
insert into Materials values(235, 'Linocut', 'linocut print');
insert into Materials values(240, 'Linocut', 'linocut reduction');
insert into Materials values(250, 'Linocut', 'painted linocut');
insert into Materials values(315, 'Mixed Media', 'collage');
insert into Materials values(345, 'Mixed Media', 'mixed media');
insert into Materials values(370, 'Mixed Media', 'sumi ink, oil crayon');
insert into Materials values(395, 'Mixed Media', 'watercolor, pronto lithograph');
insert into Materials values(410, 'Oil', 'oil');
insert into Materials values(415, 'Oil', 'oil on board');
insert into Materials values(430, 'Oil', 'oil on linen');
insert into Materials values(435, 'Oil', 'oil on paper');
insert into Materials values(450, 'Oil', 'rustoleum');
insert into Materials values(455, 'Pastel', 'chalk pastel');
insert into Materials values(460, 'Pastel', 'oil pastel');
insert into Materials values(465, 'Pastel', 'pastel');
insert into Materials values(495, 'Photo', 'digital photograph');
insert into Materials values(505, 'Photo', 'photograph');
insert into Materials values(535, 'Pottery', 'clay');
insert into Materials values(545, 'Pottery', 'clay - outdoor');
insert into Materials values(550, 'Pottery', 'earthenware');
insert into Materials values(560, 'Pottery', 'pit fired');
insert into Materials values(565, 'Pottery', 'porcelain');
insert into Materials values(580, 'Pottery', 'raku');
insert into Materials values(590, 'Pottery', 'stoneware');
insert into Materials values(610, 'Pottery', 'stoneware - raku');
insert into Materials values(615, 'Pottery', 'stoneware - salt fired');
insert into Materials values(625, 'Pottery', 'stoneware - wood fired');
insert into Materials values(635, 'Pottery', 'wood fired');
insert into Materials values(650, 'Print', 'computer art');
insert into Materials values(665, 'Print', 'monotype');
insert into Materials values(700, 'Sculpture', 'found object assemblage');
insert into Materials values(710, 'Sculpture', 'granite');
insert into Materials values(715, 'Sculpture', 'granite, ceramic');
insert into Materials values(720, 'Sculpture', 'granite, goldleaf');
insert into Materials values(730, 'Sculpture', 'mixed media');
insert into Materials values(775, 'Sculpture', 'walnut, cane, bone');
insert into Materials values(780, 'Sculpture', 'wood');
insert into Materials values(805, 'Watercolor', 'watercolor');

-- Gallery Data Entry
insert into Gallery values('Dreier', 'Stein Conservatory');
insert into Gallery values('Rubell', 'Stein Conservatory');
insert into Gallery values('Walker', 'Stein Conservatory');
insert into Gallery values('Gund', 'Old Time Mill');
insert into Gallery values('Moretti', 'Old Time Mill');
insert into Gallery values('East', 'SKAA');
insert into Gallery values('North', 'SKAA');
insert into Gallery values('Sculpture Garden', 'SKAA');
insert into Gallery values('South', 'SKAA');
insert into Gallery values('West', 'SKAA');

-- TicketPrice Data Entry
insert into TicketPrice values(2009, 50);
insert into TicketPrice values(2010, 55);
insert into TicketPrice values(2011, 60);
insert into TicketPrice values(2012, 60);
insert into TicketPrice values(2013, 60);
insert into TicketPrice values(2014, 60);
insert into TicketPrice values(2015, 60);
insert into TicketPrice values(2016, 60);
insert into TicketPrice values(2017, 60);
insert into TicketPrice values(2018, 60);
insert into TicketPrice values(2019, 65);
insert into TicketPrice values(2020, 65);
insert into TicketPrice values(2021, 70);
insert into TicketPrice values(2022, 95);

-- Artwork Data Entry
insert into Artwork values(2009, 1, 15, 'Ships in Harbor', 505, 250, 31, 'n', null, 'Dreier');
insert into Artwork values(2009, 2, 70, 'Man Sitting Assemblage', 780, 325, 1, 'n', null, 'Dreier');
insert into Artwork values(2009, 3, 95, 'Provincetown Lighthouse', 805, 375, 16, 'n', null, 'Walker');
insert into Artwork values(2009, 4, 135, 'Sailboats by the Sea', 805, 400, 2, 'n', null, 'East');
insert into Artwork values(2009, 5, 160, 'Orange Flower', 460, 175, 53, 'n', null, 'Walker');
insert into Artwork values(2009, 6, 160, 'White Flowers', 455, 210, null, 'y', '10/15/2009', 'Dreier');
insert into Artwork values(2009, 7, 190, 'Grapes and Serving Bowl', 805, 175, 47, 'n', null, 'West');
insert into Artwork values(2009, 8, 255, 'Beach', 805, 150, 10, 'n', null, 'West');
insert into Artwork values(2009, 9, 270, 'White Fish Platter', 535, 125, 13, 'n', null, 'East');
insert into Artwork values(2009, 10, 365, 'Small House', 250, 145, null, 'y', '11/4/2009', 'Dreier');
insert into Artwork values(2009, 11, 500, 'Coral Vase', 565, 125, 26, 'n', null, 'Dreier');
insert into Artwork values(2009, 12, 520, 'Eventide', 805, 150, 11, 'n', null, 'Walker');
insert into Artwork values(2009, 13, 535, 'Smoky Vase', 625, 75, 43, 'n', null, 'South');
insert into Artwork values(2009, 14, 570, 'Blue Bowl', 535, 85, 8, 'n', null, 'South');
insert into Artwork values(2009, 15, 575, 'Basket', 775, 150, 4, 'n', null, 'Dreier');
insert into Artwork values(2009, 16, 630, 'Kitchen Mixer', 60, 150, null, 'n', null, 'Dreier');
insert into Artwork values(2009, 17, 635, 'Untitled', 5, 350, null, 'n', null, 'Dreier');
insert into Artwork values(2009, 18, 645, 'Abstract Lines', 5, 350, 33, 'n', null, 'East');
insert into Artwork values(2009, 19, 650, 'Blue Flower', 505, 125, 30, 'n', null, 'Walker');
insert into Artwork values(2009, 20, 665, 'Fish Platter', 535, 150, 35, 'n', null, 'South');
insert into Artwork values(2009, 21, 740, 'Forest', 410, 125, 36, 'n', null, 'Dreier');
insert into Artwork values(2009, 22, 745, 'Buckets Hanging in a Tree', 505, 75, 50, 'n', null, 'West');
insert into Artwork values(2009, 23, 780, 'Green-Handled Vase', 590, 150, 48, 'n', null, 'Walker');
insert into Artwork values(2009, 24, 810, 'Disintegrated House', 545, 65, 49, 'n', null, 'Dreier');
insert into Artwork values(2009, 25, 825, 'Waterfalls', 505, 225, 44, 'n', null, 'East');
insert into Artwork values(2009, 26, 875, 'Ships at Sea', 75, 150, 46, 'n', null, 'Walker');
insert into Artwork values(2009, 27, 930, 'Cartoon Kitchen', 395, 150, 38, 'n', null, 'Dreier');
insert into Artwork values(2009, 28, 935, 'Red Lines, Blue and Green', 465, 150, 51, 'n', null, 'Dreier');
insert into Artwork values(2009, 29, 935, 'Untitled', 345, 85, 37, 'n', null, 'West');
insert into Artwork values(2009, 30, 955, 'Teddy Bear', 505, 150, 45, 'n', null, 'East');
insert into Artwork values(2009, 31, 940, 'Salt Fire Vase', 615, 95, 27, 'n', null, 'Dreier');
insert into Artwork values(2009, 32, 980, 'Purple and Green Seascape', 410, 250, 28, 'n', null, 'Walker');
insert into Artwork values(2009, 33, 1000, 'Sailboat', 410, 150, 24, 'n', null, 'East');
insert into Artwork values(2009, 34, 1085, 'Deserted Beach', 805, 150, 40, 'n', null, 'Dreier');
insert into Artwork values(2009, 35, 1105, 'Beach and Waves', 410, 200, 42, 'n', null, 'Dreier');
insert into Artwork values(2009, 36, 1120, 'Robot', 700, 125, null, 'y', '9/22/2009', 'Rubell');
insert into Artwork values(2009, 37, 1150, 'Casey Farm', 805, 275, 29, 'n', null, 'Rubell');
insert into Artwork values(2009, 38, 1195, 'Raku Urn', 580, 125, 6, 'n', null, 'Dreier');
insert into Artwork values(2009, 39, 1205, 'Lily', 460, 95, null, 'n', null, 'Walker');
insert into Artwork values(2009, 40, 1300, 'Flower Bouquet', 5, 250, 5, 'n', null, 'Dreier');
insert into Artwork values(2009, 41, 1310, 'Two Cupcakes', 410, 250, 19, 'n', null, 'Dreier');
insert into Artwork values(2009, 42, 1325, 'Blue Plate', 590, 125, 15, 'n', null, 'Walker');
insert into Artwork values(2009, 43, 1325, 'Green and Red Vase', 590, 95, 34, 'n', null, 'East');
insert into Artwork values(2009, 44, 1340, 'Palm Springs Wind Farm', 505, 87, 12, 'n', null, 'North');
insert into Artwork values(2009, 45, 1360, 'New York City Girl', 805, 200, 14, 'n', null, 'West');
insert into Artwork values(2009, 46, 1400, 'Raku Pearl Necklace', 195, 95, 25, 'n', null, 'Rubell');
insert into Artwork values(2009, 47, 1495, 'Farm Planting', 430, 450, 18, 'n', null, 'Rubell');
insert into Artwork values(2009, 48, 1530, 'Handbag', 100, 69, 22, 'n', null, 'North');
insert into Artwork values(2009, 49, 1600, 'Crackle Raku Vase', 580, 95, 20, 'n', null, 'East');
insert into Artwork values(2009, 50, 1630, 'Four Eggs', 415, 600, 3, 'n', null, 'Rubell');
insert into Artwork values(2009, 51, 1680, 'Green Teapot', 580, 100, 17, 'n', null, 'Rubell');
insert into Artwork values(2009, 52, 1695, 'Arctic Seals', 495, 150, 39, 'n', null, 'Dreier');
insert into Artwork values(2009, 53, 1720, 'Snowman Globe', 505, 200, 41, 'n', null, 'Walker');
insert into Artwork values(2009, 54, 1750, 'Summer Welcomes You', 805, 300, 32, 'n', null, 'East');
insert into Artwork values(2009, 55, 1810, 'Jazz Club', 410, 375, 23, 'n', null, 'Dreier');
insert into Artwork values(2009, 56, 1825, 'Three Stages of Flowers', 505, 150, null, 'y', '8/31/2009', 'Rubell');
insert into Artwork values(2009, 57, 1835, 'East Beach, RI', 410, 160, 9, 'n', null, 'Dreier');
insert into Artwork values(2009, 58, 1865, 'Twilight Seashore', 410, 275, 7, 'n', null, 'Rubell');
insert into Artwork values(2009, 59, 1880, 'Marble and Gold', 720, 500, 21, 'n', null, 'Sculpture Garden');
insert into Artwork values(2009, 60, 1885, 'Gold Snake on Box', 730, 75, 52, 'n', null, 'East');
insert into Artwork values(2010, 1, 1880, 'From the Wall', 710, 300, 4, 'n', null, 'Sculpture Garden');
insert into Artwork values(2010, 2, 1580, 'Untitled', 550, 60, 6, 'n', null, 'Gund');
insert into Artwork values(2010, 3, 15, 'Gilbert Stewart Reflections', 505, 125, 34, 'n', null, 'Gund');
insert into Artwork values(2010, 4, 820, 'Japanese Garden - Roger Williams Park', 505, 225, 49, 'n', null, 'Gund');
insert into Artwork values(2010, 5, 1030, 'Catching Little Fish', 505, 175, null, 'n', null, 'Moretti');
insert into Artwork values(2010, 6, 815, 'Kinney Azalea Garden', 410, 200, 29, 'n', null, 'Moretti');
insert into Artwork values(2010, 7, 120, 'Tai Ji (Yin Yang)', 215, 75, 12, 'n', null, 'Gund');
insert into Artwork values(2010, 8, 1855, 'Mother and Child, Mali 2009', 495, 125, 48, 'n', null, 'East');
insert into Artwork values(2010, 9, 845, 'Salt Cellar', 535, 55, null, 'y', '11/24/2010', 'North');
insert into Artwork values(2010, 10, 485, 'Spring is Here', 805, 120, 22, 'n', null, 'Moretti');
insert into Artwork values(2010, 11, 1495, 'Crushed But Still Standing', 410, 600, 5, 'n', null, 'Gund');
insert into Artwork values(2010, 12, 915, 'Lizianthus', 415, 275, 16, 'n', null, 'Gund');
insert into Artwork values(2010, 13, 1825, 'Flamingo', 495, 175, 38, 'n', null, 'Gund');
insert into Artwork values(2010, 14, 905, 'Sunset Over Narrangansett Bay', 805, 150, null, 'y', '8/28/2010', 'East');
insert into Artwork values(2010, 15, 535, 'pit fired pot', 535, 125, 13, 'n', null, 'Moretti');
insert into Artwork values(2010, 16, 540, 'Drift in Beach, Port Clyde', 805, 250, 18, 'n', null, 'Moretti');
insert into Artwork values(2010, 17, 330, 'Jar with Stopper', 130, 400, 3, 'n', null, 'Sculpture Garden');
insert into Artwork values(2010, 18, 365, 'untitled', 230, 175, 39, 'n', null, 'North');
insert into Artwork values(2010, 19, 1205, 'Sunset in Bristol', 5, 150, 31, 'n', null, 'Gund');
insert into Artwork values(2010, 20, 630, 'Time Pieces', 235, 150, 50, 'n', null, 'Moretti');
insert into Artwork values(2010, 21, 455, 'The Cove', 415, 175, 19, 'n', null, 'Moretti');
insert into Artwork values(2010, 22, 945, 'NOLA', 505, 150, 43, 'n', null, 'West');
insert into Artwork values(2010, 23, 1180, 'Vase', 635, 75, 47, 'n', null, 'Gund');
insert into Artwork values(2010, 24, 1695, 'Nantucket Seals, 2004', 505, 210, 41, 'n', null, 'West');
insert into Artwork values(2010, 25, 1680, 'Jar', 590, 85, 51, 'n', null, 'East');
insert into Artwork values(2010, 26, 700, 'Backyard Rock', 805, 250, null, 'n', null, 'Moretti');
insert into Artwork values(2010, 27, 1120, 'Hub Scout', 700, 100, 28, 'n', null, 'Sculpture Garden');
insert into Artwork values(2010, 28, 1195, 'Temple Piece', 580, 125, 40, 'n', null, 'Gund');
insert into Artwork values(2010, 29, 1525, 'The Bridge Game', 505, 250, null, 'n', null, 'Gund');
insert into Artwork values(2010, 30, 780, 'Waves and Bees', 535, 125, 8, 'n', null, 'East');
insert into Artwork values(2010, 31, 1870, 'Teatro Capitolio - Then and Now', 5, 750, 21, 'n', null, 'Moretti');
insert into Artwork values(2010, 32, 1420, 'Rocky Path', 5, 250, 23, 'n', null, 'Gund');
insert into Artwork values(2010, 33, 1085, 'Walking the Beach', 450, 200, 25, 'n', null, 'Gund');
insert into Artwork values(2010, 34, 695, 'pit fired vessel', 535, 150, 24, 'n', null, 'Gund');
insert into Artwork values(2010, 35, 1750, 'Cocktail Party', 805, 350, 2, 'n', null, 'South');
insert into Artwork values(2010, 36, 930, 'untitled', 240, 400, 14, 'n', null, 'Moretti');
insert into Artwork values(2010, 37, 1340, 'Huntington Orchid', 505, 250, 36, 'n', null, 'Moretti');
insert into Artwork values(2010, 38, 1720, 'Connecticut Barn', 505, 150, 53, 'n', null, 'East');
insert into Artwork values(2010, 39, 1040, 'Chip and Dip Tray', 535, 75, 33, 'n', null, 'Gund');
insert into Artwork values(2010, 40, 1040, 'raku vase', 535, 75, 44, 'n', null, 'North');
insert into Artwork values(2010, 41, 1400, 'Wild West Whimsey', 210, 95, 30, 'n', null, 'Moretti');
insert into Artwork values(2010, 42, 255, 'Little Reader', 805, 250, 10, 'n', null, 'West');
insert into Artwork values(2010, 43, 1370, 'Bird', 315, 75, 52, 'n', null, 'South');
insert into Artwork values(2010, 44, 1865, 'Midsummer Day Dream', 410, 350, null, 'n', null, 'Gund');
insert into Artwork values(2010, 45, 1630, 'Three Egg Cups', 415, 650, 11, 'n', null, 'East');
insert into Artwork values(2010, 46, 1835, 'Newport Bridge', 410, 225, 1, 'n', null, 'East');
insert into Artwork values(2010, 47, 645, 'Summer Rhythms 2 and 3', 5, 190, 27, 'n', null, 'Moretti');
insert into Artwork values(2010, 48, 315, 'They''re Off', 410, 200, 7, 'n', null, 'Moretti');
insert into Artwork values(2010, 49, 315, 'Light House in Rhode Island', 410, 225, 15, 'n', null, 'Gund');
insert into Artwork values(2010, 50, 315, 'Red Marsh', 410, 175, 35, 'n', null, 'South');
insert into Artwork values(2010, 51, 1530, 'Mini Tote Bag', 110, 69, 46, 'n', null, 'West');
insert into Artwork values(2010, 52, 1655, 'Grist Mill At Gilbert Stuart', 805, 150, null, 'y', '8/30/2010', 'Gund');
insert into Artwork values(2010, 53, 1325, 'vase', 610, 95, 37, 'n', null, 'Moretti');
insert into Artwork values(2010, 54, 140, 'Indian Rock', 805, 375, 17, 'n', null, 'North');
insert into Artwork values(2010, 55, 650, 'Indigo Morning', 505, 175, 32, 'n', null, 'Gund');
insert into Artwork values(2010, 56, 1000, 'After Five, Jamestown', 435, 300, 20, 'n', null, 'West');
insert into Artwork values(2010, 57, 940, 'Wine Cooler', 615, 100, 42, 'n', null, 'West');
insert into Artwork values(2010, 58, 900, 'Deadwood', 535, 150, 45, 'n', null, 'Moretti');
insert into Artwork values(2010, 59, 1875, 'Flow', 5, 550, 9, 'n', null, 'Moretti');
insert into Artwork values(2010, 60, 1875, 'Untitled', 535, 195, 26, 'n', null, 'Moretti');
insert into Artwork values(2011, 1, 35, 'Raku Jar With Lid', 580, 55, 30, 'n', null, 'Rubell');
insert into Artwork values(2011, 2, 90, 'Maelstrom II', 370, 250, 31, 'n', null, 'Walker');
insert into Artwork values(2011, 3, 120, 'Balancing Act Chakra', 190, 145, 38, 'n', null, 'North');
insert into Artwork values(2011, 4, 135, 'Summer Idyll', 805, 200, 4, 'n', null, 'East');
insert into Artwork values(2011, 5, 210, 'Untitled', 505, 200, 23, 'n', null, 'Walker');
insert into Artwork values(2011, 6, 255, 'The Beach', 805, 150, 15, 'n', null, 'West');
insert into Artwork values(2011, 7, 315, 'RI Lighthouse', 410, 80, 27, 'n', null, 'East');
insert into Artwork values(2011, 8, 315, 'Flagpole Making', 410, 65, 50, 'n', null, 'Rubell');
insert into Artwork values(2011, 9, 345, 'Light House', 535, 95, 48, 'n', null, 'Dreier');
insert into Artwork values(2011, 10, 365, 'Untitled', 75, 180, 19, 'n', null, 'East');
insert into Artwork values(2011, 11, 400, 'One White Chair', 505, 150, 49, 'n', null, 'West');
insert into Artwork values(2011, 12, 535, 'Pit Fired Pot', 535, 120, 9, 'n', null, 'East');
insert into Artwork values(2011, 13, 630, 'Admiral', 90, 200, 20, 'n', null, 'Rubell');
insert into Artwork values(2011, 14, 645, 'Water Prelude', 5, 300, 12, 'n', null, 'North');
insert into Artwork values(2011, 15, 650, 'Color For Sale', 505, 150, 40, 'n', null, 'East');
insert into Artwork values(2011, 16, 660, 'Teapot', 565, 90, 17, 'n', null, 'South');
insert into Artwork values(2011, 17, 695, 'Red Flower', 505, 200, 51, 'n', null, 'Walker');
insert into Artwork values(2011, 18, 700, 'Water Birch', 805, 150, 25, 'n', null, 'North');
insert into Artwork values(2011, 19, 745, 'Nautical', 505, 60, 16, 'n', null, 'Dreier');
insert into Artwork values(2011, 20, 780, 'Butterflies and Bugs Vase', 560, 89, 43, 'n', null, 'West');
insert into Artwork values(2011, 21, 810, 'Heart with Rough Edges', 535, 65, 53, 'n', null, 'Walker');
insert into Artwork values(2011, 22, 855, 'Clematis', 805, 150, 47, 'n', null, 'East');
insert into Artwork values(2011, 23, 975, 'Child''s Play II', 465, 125, 32, 'n', null, 'Dreier');
insert into Artwork values(2011, 24, 1000, 'Road To The Beach', 410, 175, 18, 'n', null, 'Rubell');
insert into Artwork values(2011, 25, 1085, 'Tulips and Violets', 535, 80, 33, 'n', null, 'Walker');
insert into Artwork values(2011, 26, 1085, 'Stone Aquarium', 715, 200, 42, 'n', null, 'Sculpture Garden');
insert into Artwork values(2011, 27, 1085, 'Fisherman Lamp', 535, 120, 45, 'n', null, 'Walker');
insert into Artwork values(2011, 28, 1090, 'Andiamo!', 505, 150, 24, 'n', null, 'East');
insert into Artwork values(2011, 29, 1090, 'Worthy', 505, 150, 39, 'n', null, 'West');
insert into Artwork values(2011, 30, 1195, 'Enkindled', 535, 85, 37, 'n', null, 'Dreier');
insert into Artwork values(2011, 31, 1205, 'Pt. Judith', 5, 275, 44, 'n', null, 'North');
insert into Artwork values(2011, 32, 1290, 'Autumn', 410, 400, 22, 'n', null, 'East');
insert into Artwork values(2011, 33, 1325, 'Battito Del Cuore', 535, 200, 2, 'n', null, 'Rubell');
insert into Artwork values(2011, 34, 1340, 'My Friend Purple', 505, 100, 35, 'n', null, 'West');
insert into Artwork values(2011, 35, 1395, 'Parrot', 665, 150, 29, 'n', null, 'South');
insert into Artwork values(2011, 36, 1400, 'A Victorian Moon', 145, 95, 36, 'n', null, 'Dreier');
insert into Artwork values(2011, 37, 1495, 'Still Life With Old Bucket', 410, 350, 1, 'n', null, 'North');
insert into Artwork values(2011, 38, 1525, 'Wickenden St. Gallery #2', 505, 250, 13, 'n', null, 'Walker');
insert into Artwork values(2011, 39, 1535, 'Black Hole', 650, 95, 41, 'n', null, 'East');
insert into Artwork values(2011, 40, 1590, 'High Style', 535, 95, 34, 'n', null, 'Dreier');
insert into Artwork values(2011, 41, 1590, 'My and My Shadow', 535, 100, 46, 'n', null, 'West');
insert into Artwork values(2011, 42, 1630, 'Eggcup and Butter Dish', 410, 250, 14, 'n', null, 'Walker');
insert into Artwork values(2011, 43, 1650, 'Misty', 805, 250, 6, 'n', null, 'Dreier');
insert into Artwork values(2011, 44, 1655, 'View From Jamestown', 805, 100, 28, 'n', null, 'East');
insert into Artwork values(2011, 45, 1750, 'Cocktail Party', 805, 250, 5, 'n', null, 'Rubell');
insert into Artwork values(2011, 46, 1810, 'Winter Sky', 410, 550, 7, 'n', null, 'West');
insert into Artwork values(2011, 47, 1835, 'South County Beach', 410, 200, 8, 'n', null, 'Dreier');
insert into Artwork values(2011, 48, 1865, 'Sue at Sachuest and St. George''s', 410, 300, 52, 'n', null, 'Walker');
insert into Artwork values(2011, 49, 1870, 'Brockway Mill, Vermont', 5, 825, 11, 'n', null, 'East');
insert into Artwork values(2011, 50, 1875, 'Tempestuous Rose', 5, 575, 10, 'n', null, 'West');
insert into Artwork values(2011, 51, 1875, 'Melting Vase', 535, 65, 21, 'n', null, 'North');
insert into Artwork values(2011, 52, 1875, 'Pit Fired Closed Form', 535, 175, 26, 'n', null, 'Dreier');
insert into Artwork values(2011, 53, 1880, 'Off The Wall', 710, 400, 3, 'n', null, 'Sculpture Garden');
insert into Artwork values(2011, 54, 1885, 'I''m Mellow Now', 65, 150, null, 'n', null, 'South');