----------------------------------------------
-- SQL Server - Case Sensitive Column Example
----------------------------------------------

-- Create table with a ClientId and Name columns
CREATE TABLE [dbo].[CaseSensitiveExample](
	[Id] [bigint] NOT NULL IDENTITY(1,1),
	[ClientId] varchar(100) NOT NULL,
	[Name] varchar(100) NOT NULL,
 CONSTRAINT [PK_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)) ON [PRIMARY]
GO

-- Now let's add a unique constraint on the ClientId column to make sure we do not insert a duplicate!
ALTER TABLE [dbo].[CaseSensitiveExample] ADD  CONSTRAINT [UC_CaseSensitiveExample_ClientId] UNIQUE NONCLUSTERED
(
  [ClientId] ASC
) ON [PRIMARY]
GO

-- Insert a client into the table
INSERT INTO dbo.CaseSensitiveExample (ClientId, [Name])
VALUES('clientid', 'First Client')
GO

-- Show the client that has been added
SELECT * FROM  dbo.CaseSensitiveExample

-- Now let's insert another client, with a clientId that has different casing
INSERT INTO dbo.CaseSensitiveExample (ClientId, [Name])
VALUES('CLIENTID', 'Second Client')
GO

-- Notice how, even though the ClientId is different, we get the following exception:
-- Violation of UNIQUE KEY constraint 'UC_CaseSensitiveExample_ClientId'. 
-- Cannot insert duplicate key in object 'dbo.CaseSensitiveExample'. 
-- The duplicate key value is (CLIENTID).

-- The reason is because SQL Server columns by default are case insensitive, 
-- so the value clientid and CLIENTID are duplicates as far as SQL Server is concerned.

-- Now let's update the clientId column to be case sensitive

-- First drop the unique constraint
ALTER TABLE [dbo].[CaseSensitiveExample] DROP [UC_CaseSensitiveExample_ClientId]
GO

-- Alert the column to be case insensitive
ALTER TABLE dbo.CaseSensitiveExample
ALTER COLUMN ClientId VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL
GO

-- Add back the unqiue constraint
ALTER TABLE [dbo].[CaseSensitiveExample] ADD  CONSTRAINT [UC_CaseSensitiveExample_ClientId] UNIQUE NONCLUSTERED
(
  [ClientId] ASC
) ON [PRIMARY]
GO
 
-- Now let's try and 
INSERT INTO dbo.CaseSensitiveExample (ClientId, [Name])
VALUES('CLIENTID', 'Second Client')
GO

-- Now both the first and second client have been successfully added
SELECT * FROM  dbo.CaseSensitiveExample

-- Cleanup
DROP TABLE [dbo].[CaseSensitiveExample]
GO

