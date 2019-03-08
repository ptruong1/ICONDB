CREATE TABLE [dbo].[tblFacilityMediaCommRate] (
    [FacilityID] INT            NOT NULL,
    [CommRate]   NUMERIC (4, 2) NULL,
    [InputDate]  DATETIME       NULL,
    [ModifyDate] DATETIME       NULL,
    [UserName]   VARCHAR (25)   NULL,
    CONSTRAINT [PK_tblFacilityMediaCommRate] PRIMARY KEY CLUSTERED ([FacilityID] ASC)
);

