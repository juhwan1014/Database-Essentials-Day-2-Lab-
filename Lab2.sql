USE master
GO
IF NOT EXISTS (
	SELECT name
	FROM sys.databases
	WHERE name = 'Moon_Juhwan_SSD_Ticketing'
)
BEGIN
CREATE DATABASE Moon_Juhwan_SSD_Ticketing
END
GO


USE Moon_Juhwan_SSD_Ticketing
GO



--DROP TABLES

IF OBJECT_ID('EventSeatSale', 'U') IS NOT NULL
DROP TABLE EventSeatSale;
GO
IF OBJECT_ID('EventSeat', 'U') IS NOT NULL
DROP TABLE EventSeat;
GO
IF OBJECT_ID('Seat', 'U') IS NOT NULL
DROP TABLE Seat;
GO
IF OBJECT_ID('Row', 'U') IS NOT NULL
DROP TABLE Row;
GO
IF OBJECT_ID('Section', 'U') IS NOT NULL
DROP TABLE Section;
GO
IF OBJECT_ID('Event', 'U') IS NOT NULL
DROP TABLE Event;
GO
IF OBJECT_ID('EventType', 'U') IS NOT NULL
DROP TABLE EventType;
GO
IF OBJECT_ID('Sale', 'U') IS NOT NULL
DROP TABLE Sale;
GO
IF OBJECT_ID('Customer', 'U') IS NOT NULL
DROP TABLE Customer;
GO
IF OBJECT_ID('dbo.Venue','u') IS NOT NULL
  DROP TABLE dbo.Venue
  GO


  --CREATE Tables
CREATE TABLE Venue (
	VenueId UNIQUEIDENTIFIER PRIMARY KEY, --default NEWID(),
	[Name] VARCHAR(200) NOT NULL,
	City VARCHAR(100) NOT NULL,
	[State] VARCHAR(100) NOT NULL,
	Capacity INT
)

CREATE TABLE Customer(
    CustomerId UNIQUEIDENTIFIER PRIMARY KEY,
	FirstName VARCHAR(20),
    LastName VARCHAR(20)
);

CREATE TABLE Sale(
    SaleId UNIQUEIDENTIFIER PRIMARY KEY,
	CustomerId UNIQUEIDENTIFIER,
	PaymentType VARCHAR(10)
	FOREIGN KEY(CustomerId) REFERENCES Customer(CustomerId)
);

CREATE TABLE EventType (
    EventTypeId UNIQUEIDENTIFIER PRIMARY KEY,
    Name VARCHAR(20)
);

CREATE TABLE Event(
    EventId UNIQUEIDENTIFIER PRIMARY KEY,
    EventTypeId UNIQUEIDENTIFIER,
    VenueId UNIQUEIDENTIFIER,
    [Name] VARCHAR(20),
    EventDate DATE,
    StartTime TIME
	FOREIGN KEY(EventTypeId) REFERENCES EventType(EventTypeId),
	FOREIGN KEY(VenueId) REFERENCES Venue(VenueId)
);

CREATE TABLE Section(
    SectionId UNIQUEIDENTIFIER PRIMARY KEY,
    VenueId UNIQUEIDENTIFIER,
    Name VARCHAR(20)
	FOREIGN KEY(VenueId) REFERENCES Venue(VenueId)
);

CREATE TABLE Row(
    RowId UNIQUEIDENTIFIER PRIMARY KEY,
    SectionId UNIQUEIDENTIFIER,
    RowNumber INT
	FOREIGN KEY(SectionId) REFERENCES Section(SectionId)
);

CREATE TABLE Seat(
    SeatId UNIQUEIDENTIFIER PRIMARY KEY,
    RowId UNIQUEIDENTIFIER,
    SeatNumber INT,
	BasePrice MONEY
	FOREIGN KEY(RowId) REFERENCES Row(RowId)
);

CREATE TABLE EventSeat(
    EventSeatId UNIQUEIDENTIFIER PRIMARY KEY,
    SeatId UNIQUEIDENTIFIER,
	EventId UNIQUEIDENTIFIER,
    EventPrice MONEY
	FOREIGN KEY(SeatId) REFERENCES Seat(SeatId),
	FOREIGN KEY(EventId) REFERENCES Event(EventId)
);

CREATE TABLE EventSeatSale(
    EventSeatId UNIQUEIDENTIFIER,
    SaleId UNIQUEIDENTIFIER,
	SalePrice MONEY,
    SaleStatus INTEGER default 0
	FOREIGN KEY(SaleId) REFERENCES Sale(SaleId),
	FOREIGN KEY(EventSeatId) REFERENCES EventSeat(EventSeatId),
	PRIMARY KEY (EventSeatId,SaleId)
);
GO


ALTER TABLE EventSeatSale
ADD CONSTRAINT availSaleSatus CHECK(SaleStatus IN (0,1,2,3)) 

ALTER TABLE Sale
ADD CONSTRAINT availPayType CHECK(PaymentType IN ('MC','AMEX','VISA','CASH')) 



INSERT INTO Venue VALUES (NEWID(),'American Airlines Arena','Miami','Florida','19600')
INSERT INTO Venue VALUES (NEWID(),'American Airlines Center','Dallas','Texas','19200')
INSERT INTO Venue VALUES (NEWID(),'Amway Center','Orlando','Florida','18846')
INSERT INTO Venue VALUES (NEWID(),'AT&T Center','San Antonio','Texas','18418')
INSERT INTO Venue VALUES (NEWID(),'Bankers Life Fieldhouse','Indianapolis','Indiana','17923')
INSERT INTO Venue VALUES (NEWID(),'Barclays Center','Brooklyn','New York','17732')
INSERT INTO Venue VALUES (NEWID(),'Capital One Arena','Washington','D.C.','20356')
INSERT INTO Venue VALUES (NEWID(),'Chase Center','San Francisco','California','18064')
INSERT INTO Venue VALUES (NEWID(),'Chesapeake Energy Arena','Oklahoma City','Oklahoma','18203')
INSERT INTO Venue VALUES (NEWID(),'FedExForum','Memphis','Tennessee','17794')
INSERT INTO Venue VALUES (NEWID(),'Fiserv Forum','Milwaukee','Wisconsin','17500')
INSERT INTO Venue VALUES (NEWID(),'Golden 1 Center','Sacramento','California','17583')
INSERT INTO Venue VALUES (NEWID(),'Little Caesars Arena','Detroit','Michigan','20332')
INSERT INTO Venue VALUES (NEWID(),'Madison Square Garden','New York City','New York','19812')
INSERT INTO Venue VALUES (NEWID(),'Moda Center','Portland','Oregon','19441')
INSERT INTO Venue VALUES (NEWID(),'Pepsi Center','Denver','Colorado','19520')
INSERT INTO Venue VALUES (NEWID(),'Rocket Mortgage FieldHouse','Cleveland','Ohio','19432')
INSERT INTO Venue VALUES (NEWID(),'Scotiabank Arena','Toronto','Ontario','19800')
INSERT INTO Venue VALUES (NEWID(),'Smoothie King Center','New Orleans','Louisiana','16867')
INSERT INTO Venue VALUES (NEWID(),'Spectrum Center','Charlotte','North Carolina','19077')
INSERT INTO Venue VALUES (NEWID(),'Staples Center','Los Angeles','California','18997')
INSERT INTO Venue VALUES (NEWID(),'State Farm Arena','Atlanta','Georgia','18118')
INSERT INTO Venue VALUES (NEWID(),'Talking Stick Resort Arena','Phoenix','Arizona','18055')
INSERT INTO Venue VALUES (NEWID(),'Target Center','Minneapolis','Minnesota','18978')
INSERT INTO Venue VALUES (NEWID(),'TD Garden','Boston','Massachusetts','18624')
INSERT INTO Venue VALUES (NEWID(),'Toyota Center','Houston','Texas','18055')
INSERT INTO Venue VALUES (NEWID(),'United Center','Chicago','Illinois','20917')
INSERT INTO Venue VALUES (NEWID(),'Vivint Smart Home Arena','Salt Lake City','Utah','18306')
INSERT INTO Venue VALUES (NEWID(),'Wells Fargo Center','Philadelphia','Pennsylvania','20478')
INSERT INTO Venue VALUES (NEWID(),'Inglewood Basketball and Entertainment Center','Inglewood', 'California','18000')




--INSERT Seed Data--
DECLARE @VenueId UNIQUEIDENTIFIER = (SELECT VenueId FROM Venue WHERE Name = 'Staples Center');
INSERT INTO EventType VALUES (NEWID(), 'Concert');
INSERT INTO EventType VALUES (NEWID(), 'Basketball Game');
INSERT INTO EventType VALUES (NEWID(), 'Hockey Game');

DECLARE @ConcertId UNIQUEIDENTIFIER = (SELECT EventTypeId FROM EventType WHERE Name = 'Concert');


INSERT INTO Event VALUES 
(NEWID(),  @ConcertId, @VenueId, 'Beyonce', ' 2021-04-12 18 : 00 : 00.000 ' , ' 2021-04-12 18 : 00 : 00'),
(NEWID(),  @ConcertId, @VenueId, 'Lady Gaga', '2021-05-17 18:00:00.000','2021-05-17 18:00:00.000'),
(NEWID(),  @ConcertId, @VenueId, 'Disney on Ice', '2019-12-20 16:00:00.000','2019-12-20 16:00:00.000');

INSERT INTO Section VALUES 
(NEWID(), @VenueId, 'UPPERMEZ_10'),
(NEWID(), @VenueId, 'LOWERBOWL_01');

DECLARE @SectionId UNIQUEIDENTIFIER = (SELECT SectionId FROM Section WHERE Name = 'LOWERBOWL_01');

INSERT INTO Row VALUES 
(NEWID(), @SectionId, '01'),
(NEWID(), @SectionId, '02'),
(NEWID(), @SectionId, '03'),
(NEWID(), @SectionId, '04'),
(NEWID(), @SectionId, '05');

DECLARE @RowId UNIQUEIDENTIFIER = (SELECT RowId FROM Row WHERE RowNumber = '01');
DECLARE @RowId2 UNIQUEIDENTIFIER = (SELECT RowId FROM Row WHERE RowNumber = '02');

INSERT INTO Seat VALUES 
(NEWID(), @RowId, '01', 29.88),
(NEWID(), @RowId, '02', 29.88),
(NEWID(), @RowId, '03', 29.88),
(NEWID(), @RowId, '04', 29.88),
(NEWID(), @RowId, '05', 29.88),
(NEWID(), @RowId, '06', 29.88),
(NEWID(), @RowId, '07', 29.88),
(NEWID(), @RowId, '08', 29.88),
(NEWID(), @RowId2, '01', 26.28),
(NEWID(), @RowId2, '02', 26.28),
(NEWID(), @RowId2, '03', 26.28),
(NEWID(), @RowId2, '04', 26.28),
(NEWID(), @RowId2, '05', 26.28),
(NEWID(), @RowId2, '06', 26.28),
(NEWID(), @RowId2, '07', 26.28),
(NEWID(), @RowId2, '08', 26.28);

INSERT INTO Customer VALUES
(NEWID(),'Steve', 'Rogers'),
(NEWID(),'Carol', 'Danvers'),
(NEWID(),'Peter', 'Parker')

INSERT INTO Sale VALUES
(NEWID(), (SELECT CustomerId FROM Customer WHERE LastName = 'Rogers'), 'MC'),
(NEWID(), (SELECT CustomerId FROM Customer WHERE LastName = 'Danvers'), 'CASH');



--last version--

--DECLARE @SeatId_1 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '101');
--DECLARE @SeatId_2 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '102');
--DECLARE @SeatId_3 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '103');
--DECLARE @SeatId_4 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '104');
--DECLARE @SeatId_5 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '105');
--DECLARE @SeatId_6 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '106');
--DECLARE @SeatId_7 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '107');
--DECLARE @SeatId_8 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '108');
--DECLARE @SeatId_9 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '201');
--DECLARE @SeatId_10 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '202');
--DECLARE @SeatId_11 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '203');
--DECLARE @SeatId_12 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '204');
--DECLARE @SeatId_13 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '205');
--DECLARE @SeatId_14 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '206');
--DECLARE @SeatId_15 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '207');
--DECLARE @SeatId_16 UNIQUEIDENTIFIER =  (SELECT SeatId FROM Seat WHERE SeatNumber = '208');


--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_1,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_2,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_3,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_4,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_5,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_6,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_7,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_8,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_9,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_10,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_11,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_12,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_13,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_14,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_15,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)
--INSERT INTO EventSeat VALUES (NEWID(), @SeatId_16,(SELECT EventId FROM Event WHERE Event.Name = 'Beyonce'), 68.00)


--DECLARE @EventSeatId1 UNIQUEIDENTIFIER =  (SELECT EventSeatId FROM EventSeat WHERE SeatId = @SeatId_9);
--DECLARE @EventSeatId2 UNIQUEIDENTIFIER =  (SELECT EventSeatId FROM EventSeat WHERE SeatId = @SeatId_10);
--DECLARE @EventSeatId3 UNIQUEIDENTIFIER =  (SELECT EventSeatId FROM EventSeat WHERE SeatId = @SeatId_11);
--DECLARE @EventSeatId4 UNIQUEIDENTIFIER =  (SELECT EventSeatId FROM EventSeat WHERE SeatId = @SeatId_12);



INSERT INTO EventSeat 
	SELECT NEWID(), SeatId, (SELECT EventId FROM EVENT WHERE Name = 'Beyonce'), 68.00 FROM Seat;


--last version--

--INSERT INTO EventSeatSale VALUES (@EventSeatId1,(SELECT SaleId FROM Sale WHERE PaymentType = 'MC'),
--                                   ((SELECT BasePrice FROM Seat WHERE SeatNumber = '201')+'68'), 1);
--INSERT INTO EventSeatSale VALUES (@EventSeatId2,(SELECT SaleId FROM Sale WHERE PaymentType = 'MC'),
--                                   ((SELECT BasePrice FROM Seat WHERE SeatNumber = '202')+'68'), 1);
--INSERT INTO EventSeatSale VALUES (@EventSeatId3,(SELECT SaleId FROM Sale WHERE PaymentType = 'MC'),
--                                   ((SELECT BasePrice FROM Seat WHERE SeatNumber = '203')+'68'), 1);
--INSERT INTO EventSeatSale VALUES (@EventSeatId4,(SELECT SaleId FROM Sale WHERE PaymentType = 'MC'),
--                                   ((SELECT BasePrice FROM Seat WHERE SeatNumber = '204')+'68'), 1);


INSERT INTO EventSeatSale SELECT EventSeat.EventSeatId, 
(SELECT SaleId FROM Sale 
 INNER JOIN Customer ON Sale.CustomerId = Customer.CustomerId 
  WHERE Customer.FirstName = 'Steve' AND Customer.LastName = 'Rogers'),
 (EventSeat.EventPrice + Seat.BasePrice), 1
 FROM EventSeat
 INNER JOIN Seat ON Seat.SeatId = EventSeat.SeatId
 INNER JOIN Row ON Row.RowId = Seat.RowId
 INNER JOIN Section ON Section.SectionId = Row.SectionId
 WHERE section.name = 'lowerbowl_01'
       AND row.RowNumber = '02' 
       AND (Seat.SeatNumber = '01' OR Seat.SeatNumber = '02' OR Seat.SeatNumber = '03' OR Seat.SeatNumber = '04')


								   
/*
SELECT * FROM Customer
SELECT * FROM Sale
SELECT * FROM EventType
SELECT * FROM Event
SELECT * FROM Section
SELECT * FROM Row
SELECT * FROM Seat
SELECT * FROM EventSeat
SELECT * FROM EventSeatSale
*/



set language us_english
DELETE FROM Event WHERE EventDate < GETDATE();
SELECT Venue.Name Venue , Event.Name Event , CONVERT(VARCHAR(20), Event.EventDate,107) [Event Date], 
                CAST(Event.StartTime AS VARCHAR(8)) [Start Time] From Event 
                LEFT OUTER JOIN Venue ON Venue.Name = 'Staples Center'


--IF OBJECT_ID('tempdb..#tempEvent1') IS NOT NULL
--DROP TABLE #tempEvent1
--GO

--DELETE FROM Event WHERE EventDate >  '2021-05-01 18 : 00 : 00.000 ';
-- SELECT Event.Name Event , Section.Name Section, Row.RowNumber, sum(case when EventSeatSale.EventSeatId is Null then 1 else 0 end) Avaliable
--INTO #tempEvent1
--FROM Event, Section, EventSeatSale 
--INNER JOIN Row ON (Row.RowNumber = '01'OR Row.RowNumber = '02')

SELECT Event.Name Event, Section.Name Section, row.RowNumber Row, 
      SUM(CASE WHEN eventseatSale.EventSeatId is Null THEN 1 ELSE 0 END) [Available Seats] FROM Event
INNER JOIN EventSeat ON EventSeat.EventId = Event.eventId
INNER JOIN Seat ON Seat.SeatId = EventSeat.SeatId
INNER JOIN Row ON Seat.RowId = Row.RowId
INNER JOIN Section ON Row.SectionId = Section.SectionId
LEFT JOIN EventSeatSale ON EventSeatSale.EventSeatId = EventSeat.EventSeatId

WHERE EventSeatSale.EventSeatId IS NULL GROUP BY Event.Name, Section.Name, Row.RowNumber






SELECT Customer.FirstName + ' ' + Customer.LastName Customer, Event.Name Event, Section.Name Section, Row.RowNumber Row,
	STRING_AGG(Seat.SeatNumber,',') Seats,
	COUNT(DISTINCT Seat.SeatNumber),
	FORMAT(SUM(EventSeatSale.salePrice),'C') [Sale Price],
	Sale.PaymentType
FROM Customer
	INNER JOIN Sale ON Customer.CustomerId = Sale.CustomerId
	INNER JOIN EventSeatSale ON EventSeatSale.SaleId = Sale.SaleId
	INNER JOIN EventSeat ON EventSeatSale.EventSeatId = EventSeat.EventSeatId
	INNER JOIN Seat ON EventSeat.SeatId = Seat.SeatId
	INNER JOIN Event ON EventSeat.EventId = Event.EventId
	INNER JOIN Row ON Seat.RowId = Row.RowId
	INNER JOIN Section ON row.SectionId = Section.SectionId
	INNER JOIN EventType ON Event.EventTypeId = EventType.EventTypeId
GROUP BY Sale.saleId, (Customer.FirstName+' ' + Customer.LastName), Event.Name, Section.Name, Row.RowNumber, Sale.PaymentType




SELECT Customer.FirstName + ' ' + Customer.LastName Customer, Event.Name Event, Section.Name Section, Row.RowNumber Row,
 STRING_AGG(Seat.SeatNumber,',') Seats, FORMAT(SUM(EventSeatSale.salePrice),'C') [Sale Price], Sale.PaymentType
FROM Customer
    INNER JOIN Sale ON Customer.CustomerId = Sale.CustomerId
	INNER JOIN EventSeatSale ON EventSeatSale.SaleId = Sale.SaleId
	INNER JOIN EventSeat ON EventSeatSale.EventSeatId = EventSeat.EventSeatId
	INNER JOIN Seat ON EventSeat.SeatId = Seat.SeatId
	INNER JOIN Event ON EventSeat.EventId = Event.EventId
	INNER JOIN Row ON Seat.RowId = Row.RowId
	INNER JOIN Section ON row.SectionId = Section.SectionId
	INNER JOIN EventType ON Event.EventTypeId = EventType.EventTypeId
GROUP BY Sale.saleId, (Customer.FirstName+' ' + Customer.LastName), Event.Name, Section.Name, Row.RowNumber, Sale.PaymentType



--SELECT Customer.FirstName + ' ' + Customer.LastName Customer, Event.Name Event, Section.Name Section
--       , Row.RowNumber Row, EventSeatSale.SalePrice SalePrice FROM Customer,Event,Section,Row,EventSeatSale
--LEFT JOIN Sale ON Sale.PaymentType = 'MC'


/*
SELECT * FROM Venue

SELECT Id,[Name],City,[State],Capacity FROM Venue 
ORDER BY [Name] DESC 

SELECT Id,[Name],City,[State],Capacity FROM Venue
WHERE Name LIKE '%Staples Center%'

DELETE FROM Venue WHERE Id  = (
SELECT Id FROM Venue WHERE Name = 'Staples Center'
)

SELECT COUNT(*) AS [Venue Count]
FROM Venue

INSERT INTO Venue VALUES (default,'Staples Center','Los Angeles','California','18997')

SELECT COUNT(*) AS [Venue Count]
FROM Venue


SELECT Name, City FROM Venue
WHERE State LIKE '%California%'

SELECT Name, Capacity FROM Venue
WHERE Capacity >= 19200


SELECT Name, City, State FROM Venue
WHERE (State = 'California') OR (State = 'Texas') OR (State = 'Colorado') OR (State = 'Tennessee') OR (State = 'Minnesota')
           OR (State = 'Oklahoma') OR (State = 'Louisiana') OR (State = 'Arizona') OR (State = 'Utah') OR (State = 'Oregon')


SELECT SUM(Capacity) AS [Total Venue Capacity]
FROM Venue


SELECT SUM(Capacity) AS [Western Conference Venue Capacity] FROM Venue
WHERE  (State = 'California') OR (State = 'Texas') OR (State = 'Colorado') OR (State = 'Tennessee') OR (State = 'Minnesota')
           OR (State = 'Oklahoma') OR (State = 'Louisiana') OR (State = 'Arizona') OR (State = 'Utah') OR (State = 'Oregon')
	

UPDATE Venue SET State = 'AZ' WHERE State = 'Arizona'
UPDATE Venue SET State = 'CA' WHERE State = 'California'
UPDATE Venue SET State = 'CO' WHERE State = 'Colorado'
UPDATE Venue SET State = 'DC' WHERE State = 'D.C.'
UPDATE Venue SET State = 'FL' WHERE State = 'Florida'
UPDATE Venue SET State = 'GA' WHERE State = 'Georgia'
UPDATE Venue SET State = 'IL' WHERE State = 'Illinois'
UPDATE Venue SET State = 'IN' WHERE State = 'Indiana'
UPDATE Venue SET State = 'LA' WHERE State = 'Louisiana'
UPDATE Venue SET State = 'MA' WHERE State = 'Massachusetts'
UPDATE Venue SET State = 'MI' WHERE State = 'Michigan'
UPDATE Venue SET State = 'MN' WHERE State = 'Minnesota'
UPDATE Venue SET State = 'NY' WHERE State = 'New York'
UPDATE Venue SET State = 'NC' WHERE State = 'North Carolina'
UPDATE Venue SET State = 'OH' WHERE State = 'Ohio'
UPDATE Venue SET State = 'OK' WHERE State = 'Oklahoma'
UPDATE Venue SET State = 'ON' WHERE State = 'Ontario'
UPDATE Venue SET State = 'OR' WHERE State = 'Oregon'
UPDATE Venue SET State = 'PA' WHERE State = 'Pennsylvania'
UPDATE Venue SET State = 'TN' WHERE State = 'Tennessee'
UPDATE Venue SET State = 'TX' WHERE State = 'Texas'
UPDATE Venue SET State = 'UT' WHERE State = 'Utah'
UPDATE Venue SET State = 'WI' WHERE State = 'Wisconsin'



SELECT State, COUNT(State) AS [Venue in State]
FROM Venue
GROUP BY State
*/




