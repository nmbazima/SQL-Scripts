-- Module 3 - Lab Exercise 4 - Create Timesheet Table for Compression


-- Drop the Payment.Timesheet table
USE HumanResources;
GO
DROP TABLE Payment.Timesheet 
GO



-- Drop the current partition scheme
DROP PARTITION SCHEME [psHumanResources]
GO



-- Drop the current partition function
DROP PARTITION FUNCTION [pfHumanResourcesDates]
GO



-- Create the new partition function with wider date ranges
CREATE PARTITION FUNCTION [pfHumanResourcesDates](datetime) 
AS 
RANGE RIGHT FOR VALUES (N'2012-12-31T00:00:00.000', N'2014-12-31T00:00:00.000', N'2016-12-31T00:00:00.000')
GO



-- Re-create the partition scheme
CREATE PARTITION SCHEME [psHumanResources] AS PARTITION [pfHumanResourcesDates] TO ([FG0], [FG2], [FG3], [FG1])
GO



-- Create the Timesheet table
CREATE TABLE Payment.Timesheet
(
	PersonID int NOT NULL,
	ShiftID tinyint NOT NULL,
	RegisteredStartTime datetime NOT NULL,
	RegisteredEndTime datetime NOT NULL,
	CONSTRAINT PK_Timesheet_PersonID_ShiftID_ResgisteredStartTime PRIMARY KEY (PersonID ASC, ShiftID ASC, RegisteredStartTime)
) ON psHumanResources(RegisteredStartTime);
GO



-- Insert data into the Payment.Timesheet table
DECLARE @Shift1StartTime datetime, @Shift1EndTime datetime
DECLARE @Shift2StartTime datetime, @Shift2EndTime datetime
DECLARE @Shift3StartTime datetime, @Shift3EndTime datetime

-- Set shift 1 times
SET @Shift1StartTime = '2011-09-30 07:00:00.000'
SET	@Shift1EndTime = '2011-09-30 15:00:00.000'
-- Set shift 2 times
SET @Shift2StartTime = '2011-09-30 15:00:00.000'
SET	@Shift2EndTime = '2011-09-30 23:00:00.000'
-- Set shift 3 times
SET @Shift3StartTime = '2011-09-30 23:00:00.000'
SET	@Shift3EndTime = '2011-10-01 07:00:00.000'

DECLARE @Counter smallint
SET @Counter = 1

WHILE @Counter < 1825
BEGIN 
	-- Increment the start times
	SET @Shift1StartTime = DATEADD(DAY, 1, @Shift1StartTime)
	SET @Shift2StartTime = DATEADD(DAY, 1, @Shift2StartTime)
	SET @Shift3StartTime = DATEADD(DAY, 1, @Shift3StartTime)
	-- Increment the end times
	SET @Shift1EndTime = DATEADD(DAY, 1, @Shift1EndTime)
	SET @Shift2EndTime = DATEADD(DAY, 1, @Shift2EndTime)
	SET @Shift3EndTime = DATEADD(DAY, 1, @Shift3EndTime)

	-- Exclude weekend dates
	IF DATEPART(weekday, @Shift1StartTime) NOT IN (7,1)
	BEGIN
		-- Insert the shift 1 times 
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (30, 1, @Shift1StartTime, @Shift1EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (31, 1, @Shift1StartTime, @Shift1EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (32, 1, @Shift1StartTime, @Shift1EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (33, 1, @Shift1StartTime, @Shift1EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (34, 1, @Shift1StartTime, @Shift1EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (35, 1, @Shift1StartTime, @Shift1EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (36, 1, @Shift1StartTime, @Shift1EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (37, 1, @Shift1StartTime, @Shift1EndTime)

		-- Insert the shift 2 times 
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (40, 2, @Shift2StartTime, @Shift2EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (41, 2, @Shift2StartTime, @Shift2EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (42, 2, @Shift2StartTime, @Shift2EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (43, 2, @Shift2StartTime, @Shift2EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (44, 2, @Shift2StartTime, @Shift2EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (45, 2, @Shift2StartTime, @Shift2EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (46, 2, @Shift2StartTime, @Shift2EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (47, 2, @Shift2StartTime, @Shift2EndTime)

		-- Insert the shift 3 times 
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (50, 3, @Shift3StartTime, @Shift3EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (51, 3, @Shift3StartTime, @Shift3EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (52, 3, @Shift3StartTime, @Shift3EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (53, 3, @Shift3StartTime, @Shift3EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (54, 3, @Shift3StartTime, @Shift3EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (55, 3, @Shift3StartTime, @Shift3EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (56, 3, @Shift3StartTime, @Shift3EndTime)
		INSERT INTO Payment.Timesheet (PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime)
		VALUES (57, 3, @Shift3StartTime, @Shift3EndTime)
	END

	-- Increment the counter by 1
	SET @Counter = @Counter + 1
END
