CREATE TABLE [dbo].[tblOfficeANI] (
    [AuthNo]         CHAR (10)     NOT NULL,
    [Description]    VARCHAR (50)  NULL,
    [Billabe]        BIT           NULL,
    [InputDate]      DATETIME      DEFAULT (getdate()) NULL,
    [BillingAddress] VARCHAR (100) NULL,
    [BillingCity]    VARCHAR (30)  NULL,
    [BillingState]   VARCHAR (2)   NULL,
    [BillingZipcode] VARCHAR (9)   NULL,
    CONSTRAINT [PK_tblOfficeANI] PRIMARY KEY CLUSTERED ([AuthNo] ASC)
);

