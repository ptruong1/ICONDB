CREATE TABLE [dbo].[tblVisitPhoneServer] (
    [FacilityID]   INT          NOT NULL,
    [ServerIP]     VARCHAR (16) NOT NULL,
    [Description]  VARCHAR (60) NULL,
    [ChatServerIP] VARCHAR (30) NULL,
    CONSTRAINT [PK_tblVisitPhoneServer] PRIMARY KEY CLUSTERED ([FacilityID] ASC)
);

