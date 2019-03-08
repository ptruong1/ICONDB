CREATE TABLE [dbo].[tblWUpaymentTrans] (
    [TransID]    BIGINT          NOT NULL,
    [CustAcctNo] VARCHAR (25)    NOT NULL,
    [CustName]   VARCHAR (40)    NULL,
    [Address]    VARCHAR (40)    NULL,
    [City]       VARCHAR (24)    NULL,
    [State]      VARCHAR (2)     NULL,
    [zip]        VARCHAR (10)    NULL,
    [Phone]      VARCHAR (10)    NULL,
    [MTCN]       VARCHAR (16)    NULL,
    [PaymentAmt] NUMERIC (10, 2) NULL,
    [TransDate]  VARCHAR (24)    NULL,
    [AgentZip]   VARCHAR (9)     NULL,
    [Comment]    VARCHAR (70)    NULL,
    [ClientID]   VARCHAR (9)     NULL,
    [InputDate]  DATETIME        CONSTRAINT [DF_tblWUpaymentTrans_InputDate] DEFAULT (getdate()) NULL,
    [UpdateAcct] BIT             CONSTRAINT [DF_tblWUpaymentTrans_Update] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tblWUpaymentTrans] PRIMARY KEY CLUSTERED ([TransID] ASC)
);

