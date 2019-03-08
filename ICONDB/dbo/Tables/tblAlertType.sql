CREATE TABLE [dbo].[tblAlertType] (
    [AlertTypeID]   TINYINT      NOT NULL,
    [AlertDescript] VARCHAR (20) NULL,
    CONSTRAINT [PK_tblAlertType] PRIMARY KEY CLUSTERED ([AlertTypeID] ASC)
);

