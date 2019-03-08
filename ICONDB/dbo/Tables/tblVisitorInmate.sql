CREATE TABLE [dbo].[tblVisitorInmate] (
    [InmateID]   VARCHAR (12) NOT NULL,
    [FacilityID] INT          NOT NULL,
    [VisitorID]  INT          NOT NULL,
    [InputDate]  DATETIME     NULL,
    [modifyDate] DATETIME     NULL,
    [UserName]   VARCHAR (25) NULL,
    CONSTRAINT [PK_tblVisitorInmate] PRIMARY KEY CLUSTERED ([InmateID] ASC, [FacilityID] ASC, [VisitorID] ASC)
);

