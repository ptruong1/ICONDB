CREATE TABLE [dbo].[tblStateFee] (
    [StateCode]      CHAR (2)     NOT NULL,
    [State]          VARCHAR (70) NULL,
    [AutoConnectFee] SMALLMONEY   NULL,
    [S8ConnectFee]   SMALLMONEY   NULL,
    [STConnectFee]   SMALLMONEY   NULL,
    [PIF]            SMALLMONEY   NULL,
    CONSTRAINT [PK_tblStateFee] PRIMARY KEY CLUSTERED ([StateCode] ASC)
);

