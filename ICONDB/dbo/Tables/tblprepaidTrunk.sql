CREATE TABLE [dbo].[tblprepaidTrunk] (
    [trunkNo] CHAR (4)      NOT NULL,
    [Company] VARCHAR (50)  NULL,
    [Script]  VARCHAR (100) NULL,
    CONSTRAINT [PK_tblprepaidTrunk] PRIMARY KEY CLUSTERED ([trunkNo] ASC)
);

