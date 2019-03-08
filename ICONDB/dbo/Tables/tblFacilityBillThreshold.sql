CREATE TABLE [dbo].[tblFacilityBillThreshold] (
    [FacilityID]    INT            NOT NULL,
    [CallsPerDay]   SMALLINT       NULL,
    [AmtPerDay]     NUMERIC (6, 2) NULL,
    [CallsPerWeek]  SMALLINT       NULL,
    [AmtPerWeek]    NUMERIC (6, 2) NULL,
    [CallsPerMonth] SMALLINT       NULL,
    [AmtPerMonth]   NUMERIC (6, 2) NULL,
    [ModifyDate]    DATETIME       NULL,
    [BillType]      VARCHAR (2)    NOT NULL,
    CONSTRAINT [PK_tblFacilityBillThreshold] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [BillType] ASC)
);

