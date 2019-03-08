CREATE TABLE [dbo].[tblPrepaidPaidLog] (
    [FacilityID] INT          NULL,
    [AccountNo]  VARCHAR (12) NULL,
    [PaidAmount] SMALLMONEY   NULL,
    [PaidType]   TINYINT      NULL,
    [PaidDate]   DATETIME     NULL,
    [InmateID]   VARCHAR (12) NULL
);

