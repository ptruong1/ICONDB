CREATE TABLE [dbo].[tblFacilityTechInfo] (
    [TechID]    INT           NOT NULL,
    [Company]   VARCHAR (100) NULL,
    [FirstName] VARCHAR (25)  NULL,
    [LastName]  VARCHAR (25)  NULL,
    [Address]   VARCHAR (150) NULL,
    [City]      VARCHAR (30)  NULL,
    [Zipcode]   VARCHAR (9)   NULL,
    [State]     CHAR (2)      NULL,
    [Phone]     CHAR (10)     NULL,
    [CellPhone] VARCHAR (10)  NULL,
    [Email]     VARCHAR (50)  NULL,
    CONSTRAINT [PK_tblLocTechInfo] PRIMARY KEY CLUSTERED ([TechID] ASC)
);

