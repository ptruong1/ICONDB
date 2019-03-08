CREATE TABLE [dbo].[tblBillType] (
    [Billtype] CHAR (2)     NOT NULL,
    [Descript] VARCHAR (25) NULL,
    CONSTRAINT [PK_tblBillType] PRIMARY KEY CLUSTERED ([Billtype] ASC)
);

