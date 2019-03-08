CREATE TABLE [dbo].[tblFormInmateConfig] (
    [FacilityID] INT           NOT NULL,
    [InmateID]   VARCHAR (12)  NOT NULL,
    [FormType]   TINYINT       NOT NULL,
    [PerDay]     TINYINT       NULL,
    [PerWeek]    TINYINT       NULL,
    [PerMonth]   TINYINT       NULL,
    [InputDate]  DATETIME      NULL,
    [ModifyDate] DATETIME      NULL,
    [UserName]   VARCHAR (25)  NULL,
    [UserNote]   VARCHAR (150) NULL,
    CONSTRAINT [PK_tblFormInmateConfig] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [InmateID] ASC, [FormType] ASC)
);

