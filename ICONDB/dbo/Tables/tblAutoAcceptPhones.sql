CREATE TABLE [dbo].[tblAutoAcceptPhones] (
    [PhoneNo]    VARCHAR (15)  NOT NULL,
    [FacilityID] INT           NULL,
    [Name]       VARCHAR (100) NULL,
    [InputDate]  DATETIME      NULL,
    CONSTRAINT [PK_tblAutoAcceptPhones_1] PRIMARY KEY CLUSTERED ([PhoneNo] ASC)
);

