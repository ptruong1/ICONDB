CREATE TABLE [dbo].[tblBillToNoThreshold] (
    [BillToNo]      INT            NOT NULL,
    [CallsPerDay]   SMALLINT       NULL,
    [AmtPerDay]     NUMERIC (6, 2) NULL,
    [CallsPerWeek]  SMALLINT       NULL,
    [AmtPerWeek]    NUMERIC (6, 2) NULL,
    [CallsPerMonth] SMALLINT       NULL,
    [AmtPerMonth]   NUMERIC (6, 2) NULL,
    [ModifyDate]    DATETIME       NULL,
    CONSTRAINT [PK_tblBillToNoThreshold] PRIMARY KEY CLUSTERED ([BillToNo] ASC)
);

