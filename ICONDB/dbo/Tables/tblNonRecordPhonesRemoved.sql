CREATE TABLE [dbo].[tblNonRecordPhonesRemoved] (
    [PhoneNo]    CHAR (10)     NOT NULL,
    [FacilityID] INT           NULL,
    [LastName]   VARCHAR (25)  NULL,
    [FirstName]  VARCHAR (25)  NULL,
    [DescriptID] SMALLINT      NULL,
    [UserName]   VARCHAR (25)  NULL,
    [Inputdate]  SMALLDATETIME NULL,
    [modifyDate] SMALLDATETIME NULL,
    [Note]       VARCHAR (200) NULL,
    [GroupID]    INT           NULL
);

