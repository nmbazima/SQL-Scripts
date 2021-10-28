-- Step 1: Make sure your database scope is set to Adventureworks
USE Adventureworks
GO
--End of Step 1

--Step 2: Explore the metatdata for DirectMarketing.Opportunity
sp_help 'DirectMarketing.Opportunity'
--End of Step 2

--Step 3: Alter the tables to meet requirements
ALTER TABLE DirectMarketing.Opportunity
ALTER COLUMN OpportunityID int NOT NULL;
GO

ALTER TABLE DirectMarketing.Opportunity
ALTER COLUMN ProspectID int NOT NULL;
GO

ALTER TABLE DirectMarketing.Opportunity
ALTER COLUMN DateRaised datetime NOT NULL;
GO

ALTER TABLE DirectMarketing.Opportunity
ALTER COLUMN Likelihood tinyint NOT NULL;
GO

ALTER TABLE DirectMarketing.Opportunity
ALTER COLUMN Rating char(1) NOT NULL;
GO

ALTER TABLE DirectMarketing.Opportunity
ALTER COLUMN EstimatedClosingDate date NOT NULL;
GO

ALTER TABLE DirectMarketing.Opportunity
ALTER COLUMN EstimatedRevenue decimal(10,2) NOT NULL;
GO

--End of Step 3

-- Step 4: Add a composite primary key to the table



-- Step 5: Add a foreign key to the table, linking it to the Prospect table primary key


-- Step 6: Add a default constraint that will set the DateRaised column to the current system data and time.
 


-- Step 7: Explore the metatdata for DirectMarketing.Opportunity




