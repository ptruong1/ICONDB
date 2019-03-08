CREATE TABLE [dbo].[tblpaymentType] (
    [paymentTypeID] TINYINT      NOT NULL,
    [Descript]      VARCHAR (20) NULL,
    [FeeApplied]    BIT          NULL,
    CONSTRAINT [PK_tblpaymentType] PRIMARY KEY CLUSTERED ([paymentTypeID] ASC)
);

