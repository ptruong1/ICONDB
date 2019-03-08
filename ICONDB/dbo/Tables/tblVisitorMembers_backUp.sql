CREATE TABLE [dbo].[tblVisitorMembers_backUp] (
    [MemberID]       INT           NOT NULL,
    [VisitorID]      INT           NOT NULL,
    [FirstName]      VARCHAR (25)  NOT NULL,
    [LastName]       VARCHAR (25)  NOT NULL,
    [RelationshipID] TINYINT       NOT NULL,
    [InputDate]      SMALLDATETIME NULL,
    [ModifyDate]     SMALLDATETIME NULL,
    [DLID]           VARCHAR (12)  NULL,
    [Phone]          VARCHAR (10)  NULL,
    [Address]        VARCHAR (100) NULL,
    [City]           VARCHAR (30)  NULL,
    [State]          VARCHAR (2)   NULL,
    [Zipcode]        VARCHAR (5)   NULL,
    [Status]         TINYINT       NULL
);

