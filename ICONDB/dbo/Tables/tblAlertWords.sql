CREATE TABLE [dbo].[tblAlertWords] (
    [WordListID]      INT            NOT NULL,
    [FacilityID]      INT            NULL,
    [UserName]        VARCHAR (25)   NULL,
    [ListOfWords]     VARCHAR (1000) NULL,
    [InputDate]       SMALLDATETIME  NULL,
    [ModifyDate]      SMALLDATETIME  NULL,
    [AlertEmails]     VARCHAR (500)  NULL,
    [AlertCellphones] VARCHAR (500)  NULL,
    [AlertRegPhone]   CHAR (10)      NULL,
    CONSTRAINT [PK_tblWordList] PRIMARY KEY CLUSTERED ([WordListID] ASC)
);

