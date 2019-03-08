CREATE TABLE [dbo].[tblPhones] (
    [RecordID]       BIGINT        NOT NULL,
    [phoneNo]        VARCHAR (15)  NOT NULL,
    [PIN]            VARCHAR (12)  NOT NULL,
    [LastName]       VARCHAR (25)  NULL,
    [FirstName]      VARCHAR (25)  NULL,
    [Address]        VARCHAR (50)  NULL,
    [City]           VARCHAR (20)  NULL,
    [State]          CHAR (2)      NULL,
    [Country]        VARCHAR (20)  NULL,
    [RelationshipID] TINYINT       NULL,
    [RecordOpt]      BIT           NULL,
    [AlertToPhone]   CHAR (10)     NULL,
    [AlertToCell]    VARCHAR (25)  NULL,
    [AlertToEmail]   VARCHAR (25)  NULL,
    [inputdate]      SMALLDATETIME CONSTRAINT [DF_tblPhones_inputdate] DEFAULT (getdate()) NULL,
    [ZipCode]        VARCHAR (10)  NULL,
    [FacilityID]     INT           NOT NULL,
    [modifyDate]     DATETIME      NULL,
    [InmateID]       VARCHAR (12)  NULL,
    [InputBy]        VARCHAR (25)  NULL,
    CONSTRAINT [PK_tblPhones] PRIMARY KEY CLUSTERED ([phoneNo] ASC, [PIN] ASC, [FacilityID] ASC)
);

