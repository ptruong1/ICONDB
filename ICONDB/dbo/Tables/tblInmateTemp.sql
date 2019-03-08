CREATE TABLE [dbo].[tblInmateTemp] (
    [InmateID]   VARCHAR (12)  NOT NULL,
    [LastName]   VARCHAR (25)  NULL,
    [FirstName]  VARCHAR (25)  NULL,
    [MidName]    VARCHAR (25)  NULL,
    [Status]     TINYINT       NULL,
    [FacilityId] INT           NOT NULL,
    [inputdate]  SMALLDATETIME NULL,
    [UserName]   VARCHAR (20)  NULL,
    [ModifyDate] SMALLDATETIME NULL,
    [PIN]        VARCHAR (12)  NOT NULL
);

