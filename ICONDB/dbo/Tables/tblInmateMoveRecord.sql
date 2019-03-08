CREATE TABLE [dbo].[tblInmateMoveRecord] (
    [FacilityID]        INT          NOT NULL,
    [InmateID]          VARCHAR (12) NOT NULL,
    [LastLocationID]    INT          NULL,
    [CurrentLocationID] INT          NULL,
    [ModifyDate]        DATETIME     NULL,
    [ModifyBy]          VARCHAR (20) NULL,
    CONSTRAINT [PK_tblInmateMoveRecord] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [InmateID] ASC)
);

