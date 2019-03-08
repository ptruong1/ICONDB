CREATE TABLE [dbo].[tblDirectPhones] (
    [ID]         INT          IDENTITY (1, 1) NOT NULL,
    [FacilityID] INT          NOT NULL,
    [ANI]        VARCHAR (10) NULL,
    [DirectNo]   VARCHAR (25) NULL,
    [Descript]   VARCHAR (50) NULL,
    [inputDate]  DATETIME     NULL,
    CONSTRAINT [PK_tblDirectPhones] PRIMARY KEY CLUSTERED ([ID] ASC)
);

