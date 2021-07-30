# Database-Essentials-Day-2-Lab-

## Requirements
1. Add to your lab 1 .sql script
```sql
--CREATE Tables
CREATE TABLE Customer(
    CustomerId UNIQUEIDENTIFIER,
    FirstName VARCHAR(20),
    LastName VARCHAR(20)
);

CREATE TABLE Sale(
    SaleId UNIQUEIDENTIFIER,
    CustomerId UNIQUEIDENTIFIER,
    PaymentType VARCHAR(10)
);

CREATE TABLE EventType (
    EventTypeId UNIQUEIDENTIFIER,
    Name VARCHAR(20)
);

CREATE TABLE Event(
    EventId UNIQUEIDENTIFIER,
    EventTypeId UNIQUEIDENTIFIER,
    VenueId UNIQUEIDENTIFIER,
    Name VARCHAR(20),
    StartDate DATETIME,
    EndDate DATETIME
);

CREATE TABLE Section(
    SectionId UNIQUEIDENTIFIER,
    VenueId UNIQUEIDENTIFIER,
    Name VARCHAR(20)
);

CREATE TABLE Row(
    RowId UNIQUEIDENTIFIER,
    SectionId UNIQUEIDENTIFIER,
    RowNumber INT
);

CREATE TABLE Seat(
    SeatId UNIQUEIDENTIFIER,
    RowId UNIQUEIDENTIFIER,
    SeatNumber INT,
    BasePrice MONEY
);

CREATE TABLE EventSeat(
    EventSeatId UNIQUEIDENTIFIER,
    SeatId UNIQUEIDENTIFIER,
    EventId UNIQUEIDENTIFIER,
    EventPrice MONEY
);

CREATE TABLE EventSeatSale(
    EventSeatId UNIQUEIDENTIFIER,
    SaleId UNIQUEIDENTIFIER,
    SalePrice MONEY,
    SaleStatus INT
);
```
2. Add all PRIMARY KEY and FOREIGN KEY constraints to their appropriate CREATE TABLE statement. 
***Note: EventSeatSale primary key is a composite key of EventSeatId and SaleId***
2. Add conditionals to the top of your file to drop all tables. Be sure to use the correct sequence and test your script.
3. Use ALTER TABLE to add a constraint to ensure that the EventSeatSale table SaleStatus can only be one of the following [0,1,2,3]
4. Use ALTER TABLE to add a constraint to the Sale table that only allows PaymentType of: ['MC, 'AMEX', 'VISA', 'CASH']
5. Add the following INSERT section to your script file after the create table and adding of constraint statements:

```sql
--INSERT Seed Data
DECLARE @VenueId UNIQUEIDENTIFIER = (SELECT Id FROM Venue WHERE Name = 'Staples Center');
INSERT INTO EventType VALUES (NEWID(), 'Concert');
INSERT INTO EventType VALUES (NEWID(), 'Basketball Game');
INSERT INTO EventType VALUES (NEWID(), 'Hockey Game');

DECLARE @ConcertId UNIQUEIDENTIFIER = (SELECT EventTypeId FROM EventType WHERE Name = 'Concert');

INSERT INTO Event VALUES 
(NEWID(),  @ConcertId, @VenueId, 'Beyonce', '2021-04-12 18:00:00.000','2021-04-12 22:00:00.000'),
(NEWID(),  @ConcertId, @VenueId, 'Lady Gaga', '2021-05-17 18:00:00.000','2021-05-17 22:00:00.000'),
(NEWID(),  @ConcertId, @VenueId, 'Disney on Ice', '2019-12-20 16:00:00.000','2019-12-20 19:00:00.000');

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
```
7. Add an INSERT query that puts one record into the EventSeat table for every seat in the Seat table for the 'Beyonce' concert. Make the seat "upcharge" $68.00.
7. There is a sale in the db to Steve Rogers, it was for the following: Beyonce Lower Bowl 01, Row 02, Seats 01-04. Add the appopriate records to the EventSeatSale table.

----

9. Display the Venue Name, Event Name, Date, Start Time of all up coming events.
9. Display the Event Name, Section Name, Row Name, and Number of Available Seats for the 'Beyonce' concert. Each section row should be on a seperate line within a single result set.
10. Display (one per sale) the Customer Name, Event Name, Section Name, Row Number, Seats (comma separated), Total Price and PaymentType.

***Note: You can assume that the related application only allows customers to buy one seat block (same section, same row, consecutive seats) at a time.***

***Special Note: You can put the lowest seat - highest seat as an easier query. Bonus KARMA points if you can do the comma separated version ;)***

----

## End Result
* Single .sql file
* 6 sections
    * `--CREATE DB`
    * `--DROP Tables`
    * `--CREATE Tables`
    * `--ALTER Tables`
    * `--INSERT Seed Data`
    * `--SELECT Statements`
    
## Example Output
![](https://i.imgur.com/mFvGLSw.png)

