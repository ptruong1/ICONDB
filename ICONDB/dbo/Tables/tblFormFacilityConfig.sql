CREATE TABLE [dbo].[tblFormFacilityConfig] (
    [FacilityID] INT          NOT NULL,
    [FormTypeID] TINYINT      NOT NULL,
    [PerDay]     TINYINT      NULL,
    [PerWeek]    TINYINT      NULL,
    [PerMonth]   TINYINT      NULL,
    [InputDate]  DATETIME     NULL,
    [ModifyDate] DATETIME     NULL,
    [UserName]   VARCHAR (25) NULL,
    CONSTRAINT [PK_tblFormFacilityConfig] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [FormTypeID] ASC)
);

