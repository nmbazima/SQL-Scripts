--Demonstration 3B: Working with Data Types

-- Step 1: Open a new query window to the tempdb database

USE tempdb;
GO

-- Step 2: Create the dbo.Opportunity table

CREATE TABLE dbo.Opportunity
( 
  OpportunityID int NOT NULL
    IDENTITY(1,1),
  Requirements nvarchar(50) NOT NULL,
  ReceivedDate date NOT NULL,
  LikelyClosingDate date NULL,
  SalespersonID int NULL,
  Rating int NOT NULL
);

-- Step 3: Populate the table with 2 rows

INSERT INTO dbo.Opportunity 
  (Requirements, ReceivedDate, LikelyClosingDate,
   SalespersonID,Rating)
VALUES ('n.d.', SYSDATETIME(), DATEADD(month,1,SYSDATETIME()), 34,9),
       ('n.d.', SYSDATETIME(), DATEADD(month,1,SYSDATETIME()), 37,2);

-- Step 4: Check the identity values added

SELECT * FROM dbo.Opportunity;

-- Step 5: Try to insert a specific value for OpportunityID. This will
--         fail as you cannot insert an explicit identity column value
--         in this way.

INSERT dbo.Opportunity 
  (OpportunityID, Requirements, ReceivedDate, 
   LikelyClosingDate, SalespersonID,Rating)
VALUES (3, 'n.d.', SYSDATETIME(), DATEADD(month,1,SYSDATETIME()), 34,9);

-- Step 6: Add a row without a value for LikelyClosingDate.

INSERT dbo.Opportunity (Requirements, ReceivedDate, SalespersonID,Rating)
VALUES ('n.d.', SYSDATETIME(), 72,8);

-- Step 7: Query the table to see the value in the LikelyClosingDate column

SELECT * FROM dbo.Opportunity;
GO
 
-- Step 8: Create 3 Tables with separate identity columns

CREATE TABLE dbo.FlightBookings
( FlightBookingID INT IDENTITY(1,1) NOT NULL
    CONSTRAINT PK_FlightBookings PRIMARY KEY,
  DepartureAirportCode VARCHAR(4) NOT NULL,
  ArrivalAirportCode VARCHAR(4) NOT NULL,
  CustomerID INT NOT NULL,
  DepartingAt DATETIMEOFFSET(0) NOT NULL,
  EstimatedArrival DATETIMEOFFSET(0) NOT NULL,
  IataAirlineCode VARCHAR(2) NOT NULL,
  FlightNumber VARCHAR(4) NOT NULL,
  ShortBookingDescription AS 'Flight-' + CAST(CustomerID AS VARCHAR(8)) 
    + '-' + DepartureAirportCode + '-' + ArrivalAirportCode
    + '-' + IataAirlineCode + FlightNumber
);

CREATE TABLE dbo.CarBookings
( CarBookingID INT IDENTITY(1,1) NOT NULL
    CONSTRAINT PK_CarBookings PRIMARY KEY,
  CollectionPointCode VARCHAR(3) NOT NULL,
  ReturnPointCode VARCHAR(3) NOT NULL,
  CustomerID INT NOT NULL,
  CollectingAt DATETIMEOFFSET(0) NOT NULL,
  ReturningBy DATETIMEOFFSET(0) NOT NULL,
  VehicleTypeID INT NOT NULL,
  ShortBookingDescription AS 'Car-' + CAST(CustomerID AS VARCHAR(8))
    + '-' + CollectionPointCode + '-' + ReturnPointCode
    + '-' + CAST(VehicleTypeID AS VARCHAR(8))
);

CREATE TABLE dbo.HotelBookings
( HotelBookingID INT IDENTITY(1,1) NOT NULL
    CONSTRAINT PK_HotelBookings PRIMARY KEY,
  HotelCode VARCHAR(5) NOT NULL,
  CustomerID INT NOT NULL,
  CheckinTime DATETIMEOFFSET(0) NOT NULL,
  CheckoutTime DATETIMEOFFSET(0) NOT NULL,
  RoomTypeId INT NOT NULL,
  ShortBookingDescription AS 'Hotel-' + CAST(CustomerID AS VARCHAR(8))
    + '-' + HotelCode + '-' + CAST(RoomTypeID AS VARCHAR(4))
);
GO

-- Step 9: Insert some rows into each table

INSERT dbo.FlightBookings 
  ( DepartureAirportCode, ArrivalAirportCode, CustomerID, 
    DepartingAt, EstimatedArrival, IataAirlineCode, FlightNumber)
VALUES ('MEL','LAX', 4, '2011-07-30 13:30:00 +10:00', '2011-07-30 07:45:00 -8:00', 'QF', '25'),
       ('LAX','SEA', 3, '2011-07-30 16:30:00 -8:00', '2011-07-30 18:00:00 -8:00', 'AS', '245');

INSERT dbo.CarBookings 
  ( CollectionPointCode, ReturnPointCode, CustomerID,
    CollectingAt, ReturningBy, VehicleTypeID )
VALUES ( 'MEL', 'BNE', 8, '2011-07-30 13:30:00 +10:00', '2011-07-31 07:45:00 +10:00', 6),
       ( 'LAX', 'LAX', 7, '2011-07-31 13:30:00 +10:00', '2011-07-31 07:45:00 -8:00', 6);

INSERT dbo.HotelBookings
  ( HotelCode, CustomerID, CheckinTime, CheckoutTime, RoomTypeId )
VALUES ( 'HLMEL', 15, '2011-07-30 13:30:00 +10:00', '2011-07-31 07:45:00 +10:00', 4);

INSERT dbo.FlightBookings 
  ( DepartureAirportCode, ArrivalAirportCode, CustomerID, 
    DepartingAt, EstimatedArrival, IataAirlineCode, FlightNumber)
VALUES ('MEL','LAX', 4, '2011-07-31 13:30:00 +10:00', '2011-07-31 07:45:00 -8:00', 'QF', '25'),
       ('LAX','SEA', 6, '2011-07-31 16:30:00 -8:00', '2011-07-31 18:00:00 -8:00', 'AS', '245');

INSERT dbo.CarBookings 
  ( CollectionPointCode, ReturnPointCode, CustomerID,
    CollectingAt, ReturningBy, VehicleTypeID )
VALUES ( 'MEL', 'BNE', 9, '2011-08-30 13:30:00 +10:00', '2011-08-31 07:45:00 +10:00', 6),
       ( 'LAX', 'LAX', 8, '2011-08-31 13:30:00 +10:00', '2011-08-31 07:45:00 -8:00', 6);
       
INSERT dbo.HotelBookings
  ( HotelCode, CustomerID, CheckinTime, CheckoutTime, RoomTypeId )
VALUES ( 'HLLAX', 13, '2011-07-30 13:30:00 -6:00', '2011-07-31 07:45:00 -6:00', 4);

-- Step 10: Query the 3 tables in a single view and note the overlapping ID values

SELECT FlightBookingID AS BookingID, ShortBookingDescription 
FROM dbo.FlightBookings 
UNION ALL
SELECT CarBookingID, ShortBookingDescription 
FROM dbo.CarBookings 
UNION ALL
SELECT HotelBookingID, ShortBookingDescription 
FROM dbo.HotelBookings 
ORDER BY BookingID;
GO

-- Step 11: Drop the tables

DROP TABLE dbo.FlightBookings;
DROP TABLE dbo.CarBookings;
DROP TABLE dbo.HotelBookings;
GO

-- Step 12: Create a sequence to use with all 3 tables

CREATE SEQUENCE dbo.BookingID AS INT
  START WITH 1000001
  INCREMENT BY 1;
GO

-- Step 13: Recreate the tables using the sequence for default values

CREATE TABLE dbo.FlightBookings
( FlightBookingID INT NOT NULL
    CONSTRAINT DF_FlightBookings_FlightBookingID DEFAULT (NEXT VALUE FOR dbo.BookingID)
    CONSTRAINT PK_FlightBookings PRIMARY KEY,
  DepartureAirportCode VARCHAR(4) NOT NULL,
  ArrivalAirportCode VARCHAR(4) NOT NULL,
  CustomerID INT NOT NULL,
  DepartingAt DATETIMEOFFSET(0) NOT NULL,
  EstimatedArrival DATETIMEOFFSET(0) NOT NULL,
  IataAirlineCode VARCHAR(2) NOT NULL,
  FlightNumber VARCHAR(4) NOT NULL,
  ShortBookingDescription AS 'Flight-' + CAST(CustomerID AS VARCHAR(8)) 
    + '-' + DepartureAirportCode + '-' + ArrivalAirportCode
    + '-' + IataAirlineCode + FlightNumber
);

CREATE TABLE dbo.CarBookings
( CarBookingID INT NOT NULL
    CONSTRAINT DF_CarBookings_CarBookingID DEFAULT (NEXT VALUE FOR dbo.BookingID)
    CONSTRAINT PK_CarBookings PRIMARY KEY,
  CollectionPointCode VARCHAR(3) NOT NULL,
  ReturnPointCode VARCHAR(3) NOT NULL,
  CustomerID INT NOT NULL,
  CollectingAt DATETIMEOFFSET(0) NOT NULL,
  ReturningBy DATETIMEOFFSET(0) NOT NULL,
  VehicleTypeID INT NOT NULL,
  ShortBookingDescription AS 'Car-' + CAST(CustomerID AS VARCHAR(8))
    + '-' + CollectionPointCode + '-' + ReturnPointCode
    + '-' + CAST(VehicleTypeID AS VARCHAR(8))
);

CREATE TABLE dbo.HotelBookings
( HotelBookingID INT NOT NULL
    CONSTRAINT DF_HotelBookings_HotelBookingID DEFAULT (NEXT VALUE FOR dbo.BookingID)
    CONSTRAINT PK_HotelBookings PRIMARY KEY,
  HotelCode VARCHAR(5) NOT NULL,
  CustomerID INT NOT NULL,
  CheckinTime DATETIMEOFFSET(0) NOT NULL,
  CheckoutTime DATETIMEOFFSET(0) NOT NULL,
  RoomTypeId INT NOT NULL,
  ShortBookingDescription AS 'Hotel-' + CAST(CustomerID AS VARCHAR(8))
    + '-' + HotelCode + '-' + CAST(RoomTypeID AS VARCHAR(4))
);

-- Step 14: Reinsert the same data

INSERT dbo.FlightBookings 
  ( DepartureAirportCode, ArrivalAirportCode, CustomerID, 
    DepartingAt, EstimatedArrival, IataAirlineCode, FlightNumber)
VALUES ('MEL','LAX', 4, '2011-07-30 13:30:00 +10:00', '2011-07-30 07:45:00 -8:00', 'QF', '25'),
       ('LAX','SEA', 3, '2011-07-30 16:30:00 -8:00', '2011-07-30 18:00:00 -8:00', 'AS', '245');

INSERT dbo.CarBookings 
  ( CollectionPointCode, ReturnPointCode, CustomerID,
    CollectingAt, ReturningBy, VehicleTypeID )
VALUES ( 'MEL', 'BNE', 8, '2011-07-30 13:30:00 +10:00', '2011-07-31 07:45:00 +10:00', 6),
       ( 'LAX', 'LAX', 7, '2011-07-31 13:30:00 +10:00', '2011-07-31 07:45:00 -8:00', 6);

INSERT dbo.HotelBookings
  ( HotelCode, CustomerID, CheckinTime, CheckoutTime, RoomTypeId )
VALUES ( 'HLMEL', 15, '2011-07-30 13:30:00 +10:00', '2011-07-31 07:45:00 +10:00', 4);

INSERT dbo.FlightBookings 
  ( DepartureAirportCode, ArrivalAirportCode, CustomerID, 
    DepartingAt, EstimatedArrival, IataAirlineCode, FlightNumber)
VALUES ('MEL','LAX', 4, '2011-07-31 13:30:00 +10:00', '2011-07-31 07:45:00 -8:00', 'QF', '25'),
       ('LAX','SEA', 6, '2011-07-31 16:30:00 -8:00', '2011-07-31 18:00:00 -8:00', 'AS', '245');

INSERT dbo.CarBookings 
  ( CollectionPointCode, ReturnPointCode, CustomerID,
    CollectingAt, ReturningBy, VehicleTypeID )
VALUES ( 'MEL', 'BNE', 9, '2011-08-30 13:30:00 +10:00', '2011-08-31 07:45:00 +10:00', 6),
       ( 'LAX', 'LAX', 8, '2011-08-31 13:30:00 +10:00', '2011-08-31 07:45:00 -8:00', 6);
       
INSERT dbo.HotelBookings
  ( HotelCode, CustomerID, CheckinTime, CheckoutTime, RoomTypeId )
VALUES ( 'HLLAX', 13, '2011-07-30 13:30:00 -6:00', '2011-07-31 07:45:00 -6:00', 4);

-- Step 15: Note the values now appearing in the view

SELECT FlightBookingID AS BookingID, ShortBookingDescription 
FROM dbo.FlightBookings 
UNION ALL
SELECT CarBookingID, ShortBookingDescription 
FROM dbo.CarBookings 
UNION ALL
SELECT HotelBookingID, ShortBookingDescription 
FROM dbo.HotelBookings 
ORDER BY BookingID;
GO

-- Step 16: Note that sequence values can be created on the fly

SELECT NEXT VALUE FOR dbo.BookingID AS ID,
       * 
FROM dbo.FlightBookings;
GO

-- Step 17: Re-execute the same code and note that the sequence values
--          have been "used up" in the previous SELECT statement

SELECT NEXT VALUE FOR dbo.BookingID AS ID,
       * 
FROM dbo.FlightBookings;
GO

-- Step 18: Note that when the same entry is used multiple times in a
--          SELECT statement, that the same value is used

SELECT NEXT VALUE FOR dbo.BookingID AS ID1,
       NEXT VALUE FOR dbo.BookingID AS ID2,
	   * 
FROM dbo.FlightBookings;
GO

-- Step 19: Fetch a range of sequence values

DECLARE @FirstValue sql_variant;
DECLARE @LastValue sql_variant;

EXEC sp_sequence_get_range  
    @sequence_name = 'dbo.BookingID',
    @range_size = 50,
	@range_first_value = @FirstValue OUTPUT,
	@range_last_value = @LastValue OUTPUT;

SELECT @FirstValue, @LastValue;



GO

