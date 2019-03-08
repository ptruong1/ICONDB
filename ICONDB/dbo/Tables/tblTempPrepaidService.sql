CREATE TABLE [dbo].[tblTempPrepaidService] (
    [facilityName] VARCHAR (50)  NULL,
    [PhoneNo]      CHAR (10)     NULL,
    [UsageAmt]     VARCHAR (7)   NULL,
    [ServiceFee]   VARCHAR (7)   NULL,
    [SalesTax]     VARCHAR (7)   NULL,
    [SalesTaxRate] VARCHAR (7)   NULL,
    [TotalCharge]  VARCHAR (8)   NULL,
    [OrderID]      VARCHAR (20)  NULL,
    [CCName]       VARCHAR (60)  NULL,
    [CCNo]         VARCHAR (18)  NULL,
    [CCExpMonth]   VARCHAR (2)   NULL,
    [CCExpYear]    VARCHAR (4)   NULL,
    [CCcvv]        VARCHAR (4)   NULL,
    [CCAddresNo]   VARCHAR (200) NULL,
    [CCzip]        VARCHAR (5)   NULL,
    [paymentDate]  DATETIME      NULL
);

